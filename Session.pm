package Session;

use strict;
use warnings;
use Carp;
use POSIX;
use JSON;
use HTTP::Request;
use Data::Dumper::Concise;


sub new {
  my $class = shift;
  my $self = { @_ };
  bless($self, $class);
  $self->socket->blocking(0);
  binmode $self->socket,  ':raw';
  $self->select->add($self->socket); 
  $self->{'json'} = JSON->new();
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


sub name {
  my $self = shift;
  
  return $self->{'name'} if $self->{'name'};
  
  if (ref($self->socket) eq 'GLOB' && $self->{'pid'}) { 
    $self->{'name'} = 'pid='.$self->{'pid'}; 
  }  
  if (ref($self->socket) eq 'IO::Socket::INET' && $self->socket->sockhost()) { 
    $self->{'name'} = $self->socket->sockhost().':'.$self->socket->sockport().'-'.$self->socket->peerhost().':'.$self->socket->peerport(); 
  }
  return $self->{'name'} || $self->socket;
}

sub echo {
  my $self = shift;
  return $self->{'echo'};
}

sub socket {
  my $self = shift;
  return $self->{'socket'};
}


sub realm {
  my $self = shift;
  my $hostname = `hostname`;
  chomp $hostname;
  return $self->{'realm'} || 'AtlasV@'.$hostname;
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


# Check "Authorization:" header, load user session and return 1 if valid
sub auth_check {
  my $self = shift;
  my $req = shift;

  my $realm = $self->realm();
  my $socket = $self->socket();
  
  #warn "$0 $$ auth_check request = ".Dumper($req);
  # Extract Authorization request header from client, if any
  my $client = {};
  if ($req->header('authorization')) {
    foreach my $kv (split(/\,*\s/, $req->header('authorization'))) {
      #warn "$0 $$ auth_check kv: $kv\n";
      my ($key, $value) = split(/=/, $kv, 2);
      next unless $value;
      $value =~ s/^\"(.*)\"$/$1/; # Remove double quotes, if any
      $client->{lc($key)} = $value;
    }
  }

  # Check for complete request
  #warn "$0 $$ authorization request = ".Dumper($client)."\n";
  unless (exists $client->{'username'}) { return 0; }
  unless (exists $client->{'realm'}) { return 0; }
  unless (exists $client->{'nonce'}) { return 0; }
  unless (exists $client->{'uri'}) { return 0; }
  unless (exists $client->{'response'}) { return 0; }
  unless (exists $client->{'opaque'}) { return 0; }
  unless (exists $client->{'nc'}) { return 0; }
  unless (exists $client->{'cnonce'}) { return 0; }

  # Request is complete, now verify it
  #warn "$0 $$ authorization request from ".$client->{'username'}." appears to be complete\n";

  # Fetch HA1 from SQL table 'users'
  $client->{'username'} =~ s/\W//g;
  my $pwentries = $self->query("
    SELECT *
    FROM users
    WHERE username = '".$client->{'username'}."'
    AND realm = '".$realm."'
  ");
  unless (@{$pwentries}) {
    #warn "$0 $$ auth_check() username \"".$client->{'username'}."\" rejected\n";
    return -1; # This has no chance of ever working
  }
  my $pwentry = shift @{$pwentries};
  my $ha1 = $pwentry->{'password'} || '';
  #warn "$0 $$ fetched pwentry ".Dumper($pwentry);
  #warn "$0 $$ HA1=$ha1\n";

  # Make HA2 from request method + uri
  #warn "$0 $$ request = ".Dumper($req);
  my $ha2 = Digest::MD5::md5_hex($req->method.':'.$req->uri);
  #warn "$0 $$ HA2=$ha2\n";
  

  # Validate "opaque" key exists and is not expired
  $client->{'opaque'} =~ s/\W//g;
  print $socket "key realm=$realm opaque=".$client->{'opaque'}."\n";
  my $opaque = <$socket>;
  chomp $opaque;
  if ($opaque ne $client->{'opaque'}) {
    #warn "$0 $$ auth_check() opaque/key ".$client->{'opaque'}." rejected\n";
    return 0; # Try again
  }

  
  # Validate "nonce" value exists, is not expired and is associated with opaque/key
  $client->{'nonce'} =~ s/\W//g;
  print $socket "nonce realm=$realm nonce=".$client->{'nonce'}." nc=".$client->{'nc'}." opaque=".$client->{'opaque'}."\n";
  my $nonce = <$socket>;
  chomp $nonce;
  if ($nonce ne $client->{'nonce'}) {
    #warn "$0 $$ auth_check() nonce ".$client->{'nonce'}." rejected\n";
    return 0; # Try again
  }
  
  
  # Assemble final check string and validate response
  my $final = $ha1.':'.$nonce.':'.$client->{'nc'}.':'.$client->{'cnonce'}.':'.$client->{'qop'}.':'.$ha2;
  my $correct = Digest::MD5::md5_hex($final);
  if ($client->{'response'} eq $correct) {
    return 1; # PASS
  }
      
  #warn "$0 $$ incorrect response ".$client->{'response'}." (should be ".$correct.")\n";

  return -1; # The password is incorrect, no chance of ever working
} 

# Return a HTTP Digest authentication challenge header - Note: BLOCKING
sub auth_challenge {
  my $self = shift;
  my $req = shift;
  
  my $realm = $self->realm();
  my $socket = $self->socket();
  
  # Extract Authorization request header from client, if any
  my $client = {};
  if ($req->header('authorization')) {
    foreach my $kv (split(/\,*\s/, $req->header('authorization'))) {
      #warn "$0 $$ auth_check kv: $kv\n";
      my ($key, $value) = split(/=/, $kv, 2);
      next unless $value;
      $value =~ s/^\"(.*)\"$/$1/; # Remove double quotes, if any
      $client->{lc($key)} = $value;
    }
  }
  #warn $client->{'username'};
  #if ($client->{'username'} eq '#null') { $client = {}; } # Firefox workaround
  
  # Generate (or reuse) "opaque" as the key of authenticated user, if any
  $client->{'opaque'} =~ s/\W//g if $client->{'opaque'};
  print $socket "key realm=$realm opaque=".($client->{'opaque'}||'')."\n";
  my $opaque = <$socket>;
  chomp $opaque;
  
  # Generate a new "nonce" value and tie it to the opaque value
  print $socket "nonce realm=$realm opaque=$opaque\n";
  my $nonce = <$socket>;
  chomp $nonce;
  
  if ($client->{'nonce'}) {
    #warn "$0 $$ issued new nonce (stale=TRUE)\n";
    return ( WWW_Authenticate => "Digest realm=\"$realm\", qop=\"auth,auth-int\", nonce=\"$nonce\", opaque=\"$opaque\", stale=TRUE" );
  } else {
    #warn "$0 $$ issued new nonce\n";
    return ( WWW_Authenticate => "Digest realm=\"$realm\", qop=\"auth,auth-int\", nonce=\"$nonce\", opaque=\"$opaque\"" );
  }
}


sub query {
  my $self = shift;
  my $query = shift;
  
  my $socket = $self->socket;
  $query =~ s/\n/ /g;
  print $socket $query."\n";
  my $cols = [];
  my @records = ();
  while (my $line = <$socket>) {
    chomp $line;
    last unless $line; # Empty line = end of response
    next if $line =~ /^#/; # Comment/message
    if ($line =~ /^\!/) {
      # Error
      warn "$0 $$ $line\n";
      last;
    }
    #warn "$0 $$ decode line=".$line."\n";
    if ($line =~ /^\@(.*)/) {
      my $encoded = $1 || '[]';
      $cols = $self->{'json'}->decode($encoded);
      next; 
    }
    my $row = $self->{'json'}->decode($line);
    my %hash = ();
    @hash{@{$cols}} = @{$row};
    push @records, \%hash;
    #warn "$0 $$ hash=".Dumper(\%hash);
  } 
  return \@records;
}


return 1;

