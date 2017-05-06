package Session;

use strict;
use warnings;
use Carp;
use POSIX;
use HTTP::Request;


sub new {
  my $class = shift;
  my $self = { @_ };
  bless($self, $class);
  $self->socket->blocking(0);
  binmode $self->socket,  ':raw';
  $self->select->add($self->socket); 
  return $self;
}


sub peer {
  my $self = shift;
  
  return $self->{'peer'} if $self->{'peer'};
  
  if (ref($self->socket) eq 'GLOB' && $self->{'pid'}) { 
    $self->{'peer'} = 'pid='.$self->{'pid'}; 
  }  
  if (ref($self->socket) eq 'IO::Socket::INET' && $self->socket->peerhost()) { 
    $self->{'peer'} = $self->socket->peerhost().':'.$self->socket->peerport(); 
  }
  return $self->{'peer'} || $self->socket;
}

sub echo {
  my $self = shift;
  return $self->{'echo'};
}

sub socket {
  my $self = shift;
  return $self->{'socket'};
}


sub dbh {
  my $self = shift;
  return $self->{'dbh'};
}

sub select {
  my $self = shift;
  return $self->{'select'};
}


sub type {
  my $self = shift;
  return $self->{'type'};
}


sub connected {
  my $self = shift;
  return $self->socket->connected();
}

sub closed {
  my $self = shift;
  return $self->{'closed'} ? 1 : 0;
}

sub close {
  my $self = shift;
  $self->select->remove($self->socket);
  $self->socket->close();
  $self->{'closed'} = 1;
}

sub finish {
  my $self = shift;
  $self->{'close'} = 1; # Socket will close when output buffer is empty
}

sub read {
  my $self = shift;
  my $total = 0;
  while (1) {
    my $octets = $self->socket->sysread(my $buffer, POSIX::BUFSIZ);
    return $total unless defined $octets; # Would block
    if ($octets == 0) { $self->close(); return $total; }
    $self->{'input'} .= $buffer;
    $total += $octets;
  }
  croak "Attempted to read from closed socket ".$self->socket.": $self";  
}


sub write {
  my $self = shift;
  my $total = 0;
  while (1) {
    unless ($self->{'output'}) {
      if ($self->{'close'}) { $self->close(); }
      return $total;
    }
    my $buffer = substr($self->{'output'}, 0, POSIX::BUFSIZ);
    my $octets = $self->socket->syswrite($buffer);
    return $total unless defined $octets; # Would block
    if ($octets == 0) { $self->close(); return $total; }
    $self->{'output'} = substr($self->{'output'}, $octets);
    $total += $octets;
  }
  croak "Attempted to write to closed socket ".$self->socket.": $self";  
}


sub send {
  my $self = shift;
  my $data = shift;
  $self->{'output'} .= $data;
}

sub get_line {
  my $self = shift;
  if ($self->{'input'} && $self->{'input'} =~ /^(.*?\n)/) {
    my $line = $1;
    $self->{'input'} = substr($self->{'input'}, length($line));
    return $line;
  } else {
    return undef;
  }
}


sub get_http_request {
  my $self = shift;
  my $buffer = $self->{'input'};
  my $req = {};

  # Initial parsing is just to determine if we have a complete request
  # and remove it from the input stream

  # Get request line
  #warn "get request line\n";
  my $line = $self->get_line();
  if ($line && $line =~ /^(\w+)\s+(\S+)(?:\s+(\S+))?\r?\n$/) {
    $req->{'method'} 	= $1;
    $req->{'uri'} 	= $2;
    $req->{'proto'}	= $3;
  } else {
    #warn "incomplete request\n";
    $self->{'input'} = $buffer; 
    return undef;
  }

  # Get request headers
  #warn "get request headers\n";
  my $complete = 0;
  while (my $line = $self->get_line()) {
    $line =~ s/[\r\l\n\s]+$//;
    if ($line eq "") { $complete = 1; last; }
    my ($field, $value) = split(/:\s*/, $line, 2);
    $req->{'header'}->{$field} = $value;
  }
  unless ($complete) {
    #warn "incomplete request\n";
    $self->{'input'} = $buffer; 
    return undef;
  }

  # Get POST data, if any
  if ($req->{'method'} eq 'POST') {
    #warn "get request content\n";
    my $want = $req->{'header'}->{'Content-Length'} || 0;
    if ($want > length($self->{'input'})) {
      #warn "incomplete request\n";
      $self->{'input'} = $buffer; 
      return undef;
    } else {
      $self->{'input'} = substr($self->{'input'}, $want);
    }
  }   

  # If we got this far, the buffer contains a complete request
  return HTTP::Request->parse($buffer);
}



return 1;

