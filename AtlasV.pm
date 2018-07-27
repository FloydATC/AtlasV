package AtlasV;

use strict;
use warnings;
use Data::Dumper;
use Carp;

sub new {
  my $class = shift;
  my $self = { @_ };
  bless($self, $class);
  return $self;
}

sub db {
  return ( 
    'dbi:mysql:dbname=atlas5', 'atlas5', 'atlas5',
    { 
      ShowErrorStatement  => 1,
      AutoCommit          => 1,
      RaiseError          => 0,
      PrintError          => 0, 
    } 
  );
}

sub brieftime {
  my $time = shift || time;
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($time);
  return sprintf("%04d-%02d-%02d %02d:%02d:%02d", $year+1900, $mon+1, $mday, $hour, $min, $sec);
}

return 1;

