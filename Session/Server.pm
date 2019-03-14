package Session::Server;

use strict;
use warnings;

use Session::Async;

use Carp;
use IO::Socket::INET;
use IO::Select;
use IO::Handle;
use Fcntl;
use POSIX;
use Data::Dumper;

1;

sub new {
  my $class = shift;
  my $self = { @_ };
  bless $self, $class;
  
  $self->{'select'} = IO::Select->new();
  $self->{'bufsize'} |= POSIX::BUFSIZ;
  
  $SIG{CHLD} = "IGNORE";
  
  return $self;
}

sub listen {
  my $self = shift;
  my %opt = @_;
  
  #print Dumper(@_);  
  my $socket = IO::Socket::INET->new( %opt) or confess "Can't bind : $@";
  IO::Handle::blocking($socket, 0);
  
  $self->add_socket($socket, read => \&accept );
  print "Listening on ".inet_ntoa($socket->sockaddr)." port ".$socket->sockport.": $socket\n";
}

sub start {
  my $self = shift;
  
  while (1) {
    my ($can_read, $can_write, $has_exception) = IO::Select->select($self->{'select'}, $self->{'select'}, $self->{'select'}, 30);

    foreach my $socket (@{$can_read}) {
      if ($self->{'sockets'}->{$socket}->{'read'}) {
        $self->{'sockets'}->{$socket}->{'read'}->($self, $socket);
      } else {
        # Use default read handler
        $self->sysread($socket); ;
      }
    }

    foreach my $socket (@{$can_write}) {
      next unless $socket->connected; # May have disconnected during read phase
      if ($self->{'sockets'}->{$socket}->{'write'}) {
        $self->{'sockets'}->{$socket}->{'write'}->($self, $socket);
      } else {
        # Use default write handler
        $self->syswrite($socket);
      }
    }

    foreach my $socket (@{$has_exception}) {
      next unless $socket->connected; # May have disconnected during read/write phase
      print "Socket has exception: $socket\n";
      if ($self->{'sockets'}->{$socket}->{'exception'}) {
        $self->{'sockets'}->{$socket}->{'exception'}->($self, $socket);
      } else {
        # No exception handler
        print "Internal error: No exception handler for $socket\n";
      }
    }
    
  }
}

sub accept {
  my $self = shift;
  my $server = shift;
  
  #print "Accepting new socket connection on $server\n";
  my $socket = $server->accept();

  unless ($socket) {
    # We're not really interested if it failed.
    warn "Accept failed on $server\n";
    return;
  } 
  
  binmode($socket);  
  $socket->blocking(0);
  $self->add_socket($socket);
  
  if ($self->{'onClientConnect'}) {
    $self->{'onClientConnect'}->($socket);
  }
}

sub add_socket {
  my $self = shift;
  my $socket = shift;
  
  $self->{'sockets'}->{$socket} = { @_ };
  $self->{'sockets'}->{$socket}->{'socket'} = $socket;
  $self->{'sockets'}->{$socket}->{'readbuf'} = '';
  $self->{'sockets'}->{$socket}->{'writebuf'} = '';
  $self->{'sockets'}->{$socket}->{'close'} = 0;
  $self->{'select'}->add($socket);
}

sub spawn_process {
  my $self = shift;
  my %opt = @_;
  
  my $process = Session::Async->new( %opt );
  
  if ($opt{'echo'}) {
    unless ($opt{'echo'}->can('connected') && $opt{'echo'}->connected()) {
      croak "WARNING! $process 'echo' parameter is not a connected INET or UNIX socket";
    }
  }
  
  my $socket = $process->socket;
  $self->add_socket( $socket, process => $process );
  $self->{'procs'}->{$process} = $process;
  #print "Spawned a child process $process attached to socket $socket\n"; 

  if ($self->{'onClientConnect'}) {
    $self->{'onClientConnect'}->($socket);
  }

}

sub remove_socket {
  my $self = shift;
  my $socket = shift;
  
  if ($self->{'onClientDisconnect'}) {
    $self->{'onClientDisconnect'}->($socket);
  }
  
  # Check if socket belongs to a child process
  if ($self->{'sockets'}->{$socket}->{'process'}) {
    my $process = $self->{'sockets'}->{$socket}->{'process'};
    #print "Process $process (".$process->{'cmd'}.") ended\n";
    # Is this a persistent process? Re-spawn it
    if ($self->{'procs'}->{$process}->{'persist'}) {
      print "Restarting persistent process\n";
      $self->spawn_process( persist => 1, exec => $process->{'exec'}, args => $process->{'args'} );
    }
    delete $self->{'procs'}->{$process};
  }
  
  delete $self->{'sockets'}->{$socket};
  $self->{'select'}->remove($socket);
}

sub sysread {
  my $self = shift;
  my $socket = shift;

  my $total = 0;
  #print "About to sysread...\n";
  my $buffer = '';
  my $bytes = sysread($socket, $buffer, $self->{'bufsize'});
  if ($bytes > 0) {
    #print "sysread got $bytes bytes\n";
    $self->{'sockets'}->{$socket}->{'readbuf'} .= $buffer;
    $total += $bytes;
  }
  #print "Sysread done. Total=$total. Buffer contains [".$self->{'sockets'}->{$socket}->{'readbuf'}."]\n";

  # If total == 0 then a non-blocking socket closed
  if ($total == 0) {
    $socket->close;
    $self->remove_socket($socket);
    return;
  } 

  # Echo?
  if (my $process = $self->{'sockets'}->{$socket}->{'process'}) {
    #print "sysread() from a process, checking for echo\n";
    if (my $echo = $self->{'procs'}->{$process}->{'echo'}) {
      #print "sysread() from $process, redirecting output to $echo: ".$self->{'sockets'}->{$socket}->{'readbuf'};
      $self->send($echo, $self->{'sockets'}->{$socket}->{'readbuf'});
      $self->{'sockets'}->{$socket}->{'readbuf'} = '';
      return;
    }
  }   

  # Callback?
  $buffer = $self->{'sockets'}->{$socket}->{'readbuf'};
  if ($self->{'onReceive'}) {
    $buffer = $self->{'sockets'}->{$socket}->{'readbuf'};
    while ($buffer =~ /^(.*?\n)/) {
      my $message = $1;
      $self->{'onReceive'}->($socket, $message);
      $buffer = substr($buffer, length($message));
    }
    $self->{'sockets'}->{$socket}->{'readbuf'} = $buffer;
  } else {
    warn "No onReceive callback\n"; 
  }
}

sub syswrite {
  my $self = shift;
  my $socket = shift;

  my $buffer = $self->{'sockets'}->{$socket}->{'writebuf'};
  while (my $bytes = syswrite($socket, $buffer, $self->{'bufsize'})) {
    $buffer = substr($buffer, $bytes);
  }
  $self->{'sockets'}->{$socket}->{'writebuf'} = $buffer;
  
  # Check if we are waiting to close this socket and the buffer is empty
  if ($self->{'sockets'}->{$socket}->{'writebuf'} eq '' && $self->{'sockets'}->{$socket}->{'close'} == 1) {
    $socket->close;
  }
}

sub send {
  my $self = shift;
  my $socket = shift;
  my $message = shift;

  return if $self->{'sockets'}->{$socket}->{'close'}; # We are trying to close this session
    
  $self->{'sockets'}->{$socket}->{'writebuf'} .= $message;
}

sub close {
  my $self = shift;
  my $socket = shift; # Socket to close when write buffer has been flushed
  
  $self->{'sockets'}->{$socket}->{'close'} = 1;
}

sub shutdown {
  my $self = shift;
  
  foreach my $entry (values %{$self->{'sockets'}}) {
    $entry->{'socket'}->close();
  }
  foreach my $entry (values %{$self->{'procs'}}) {
    kill -9, $entry->{'pid'};
  }
}

