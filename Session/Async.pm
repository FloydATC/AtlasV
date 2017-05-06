package Session::Async;

use strict;
use warnings;
use parent 'Session';
use Session;
use Carp;


sub new {
  my $class = shift;
  my $self = { @_ };
  confess "Parameter 'cmd' missing" unless $self->{'cmd'};
  
  bless($self, $class);
  my $pid = open(my $socket, "-|"); # pipe4, http://docstore.mik.ua/orelly/perl/cookbook/ch16_11.html
  unless (defined $pid) { confess "$0 $$ forking open() failed: $!"; }
  if ($pid) {
    # Parent
    $socket->autoflush(0);
    $socket->blocking(0);
    $self->{'socket'} = $socket;
    $self->{'pid'} = $pid;
    $self->select->add($socket);    
    #warn "$0 $$ spawned a child: ".$self->peer()."\n";
    return $self;
  } else {
    #warn "child $$ spawned\n";
    my $dbh = $self->{'dbh'};
    #$self->{'dbh'} = $dbh->clone();
    
    # Destroy this copy of $dbh without affecting the connection
    $dbh->{'InactiveDestroy'} = 1;
    
    # Establish a bidirectional socket
    $self->{'socket'} = IO::Socket::INET->new(
      PeerHost	=> 'localhost',
      PeerPort	=> 1337,
      Proto	=> 'tcp',      
    ) || die "! $0 $$ Error connecting to parent process: $@\n"; 
    #warn "child $$ established two-way socket\n";
    
    $self->{'args'} ||= [];

    my $proc = ' '.$self->{'cmd'};
    #if (@{$self->{'args'}}) { $proc .= ' '.join(' ', @{$self->{'args'}}); }
    $0 .= $proc;
    $self->{'pid'} = $$;
    #warn "$0 $$ spawned as ".$self->name()."\n";
    $self->{'socket'}->autoflush();
    STDOUT->autoflush(1);
    STDERR->autoflush(1);
    #warn "$$ ready to execute\n";
    eval { $self->execute() };
    die $@ if $@;
    die "$0 $$ internal error, execute() should never return!";
  }
  
}


sub execute {
  my $self = shift;
  # Do whatever is indicated in $self
  # Send output to parent process by printong to STDOUT
  # Send output to console by printing to STDERR


  my $fname = $self->{'cmd'};
  local @ARGV = @{$self->{'args'}};
  unless (-e $fname) { $self->fail($fname, "file not found (see 'help' ?)"); } 
  unless (-f $fname) { $self->fail($fname, "not a plain file"); } 
  unless (-o $fname) { $self->fail($fname, "not owned by uid=".$<); } 
  unless (-r $fname) { $self->fail($fname, "read permission denied"); } 
  unless (-x $fname) { $self->fail($fname, "execute permission denied"); } 
  my $code = $self->read_file($fname);
  #warn "$0 $$ loaded $fname (".length($code)." bytes)\n";
  my $sessions = $self->{'sessions'};
  my $session = $self->{'socket'};
  eval $code;
  if ($@) { 
    $self->fail($fname, "CRASHED with ".$@);
  }

  # Do not return to caller
  exit;
}


sub fail {
  my $self = shift;
  my $fname = shift;
  my $message = shift;
  chomp $message;
  print STDOUT "! ".$fname." failed: ".$message."\n" if $self->{'type'} eq 'line';
  print STDERR "$0 $$ ".$fname." failed: ".$message."\n";
  exit;
}

sub read_file {
  my $self = shift;
  my $fname = shift;
  
  local $/ = undef;
  open(my $fh, '<', $fname) || die "!$fname: $!";
  my $contents = <$fh>;
  close $fh;
  
  return $contents;
}



return 1;


