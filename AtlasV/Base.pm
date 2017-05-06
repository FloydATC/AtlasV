package AtlasV::Base;

# Base class for hosts, hostgroups, sites, sitegroups etc.

use strict;
use warnings;

sub new {
  my $class = shift;
  my $self = { @_ };
  bless($self, $class);
  $self->init(); # Perform self-check and set up relationships
  return $self;
}

sub init {
  # Overload in subclasses
  return 1;
}

return 1;

