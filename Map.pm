package Map;

# This module serves as an interface between the web templates and the AtlasV core

use strict;
use warnings;
use Carp;
use JSON;
use Data::Dumper::Concise;

sub new {
  my $class = shift;
  my $self = { @_ };
  confess "Parameter 'session' missing/invalid ref=(".ref($self->{'session'}).")" unless ref($self->{'session'}) eq 'Session::Async';
  $self->{'json'} = JSON->new();
  bless($self, $class);
  return $self; 
}


sub sites {
  my $self = shift;
  my $records = $self->query('SELECT * FROM sites');
  foreach my $record (@{$records}) {
    my $id = $record->{'id'};
    my $name = $record->{'name'};
    # Raw coordinates must be padded
    my $x = $record->{'x'} || 100; 
    my $y = $record->{'y'} || 100;
    $record->{'svg'} .= "<svg x=\"$x\" y=\"$y\" id=\"site$id\" onclick=\"map.site_click(evt, 'site$id');\" onmousedown=\"map.site_mousedown(evt, 'site$id');\" onmouseup=\"map.site_mouseup(evt, 'site$id');\" onmousemove=\"map.site_mousemove(evt, 'site$id');\" onmouseover=\"map.site_mouseover(evt, 'site$id');\" onmouseout=\"map.site_mouseout(evt, 'site$id');\">\n";
    $record->{'svg'} .= "<image x=\"5\" y=\"5\" width=\"40\" height=\"40\" xlink:href=\"/static/PNG/Ukjent.png\" />\n";
    $record->{'svg'} .= "<circle cx=\"25px\" cy=\"25px\" r=\"20px\" class=\"alive\">\n";
    $record->{'svg'} .= "</circle>\n";
    $record->{'svg'} .= "<text x=\"5\" y=\"54.9\" font-size=\"9\">$name</text>\n";
    $record->{'svg'} .= "<text x=\"5\" y=\"63.9\" font-size=\"9\">XXXXXXXX</text>\n";
    $record->{'svg'} .= "</svg>\n";
  }
  return $records;
} 


sub sitegroups {
  my $self = shift;
  my $records = $self->query("
    SELECT
      MIN(sites.x) AS x1,
      MIN(sites.y) AS y1,
      MAX(sites.x) AS x2,
      MAX(sites.y) AS y2,
      sitegroups.id,
      sitegroups.name
    FROM sites
    INNER JOIN sitegroupmembers ON (sitegroupmembers.site = sites.id)
    LEFT JOIN sitegroups ON (sitegroups.id = sitegroupmembers.sitegroup)
    GROUP BY sitegroups.id
  ");
  foreach my $record (@{$records}) {
    my $id = $record->{'id'};
    my $name = $record->{'name'};
    # Raw coordinates must be padded
    my $x = $record->{'x1'} - 30;
    my $y = $record->{'y1'} - 30;
    my $w = ($record->{'x2'} - $record->{'x1'}) + 110;
    my $h = ($record->{'y2'} - $record->{'y1'}) + 110;
    $record->{'svg'} .= "<svg x=\"$x\" y=\"$y\" width=\"$w\" height=\"$h\" onclick=\"map.sitegroup_click(evt, 'sitegroup$id')\" class=\"sitegroup\" id=\"sitegroup$id\">\n";
    $record->{'svg'} .= "<rect x=\"0\" y=\"0\" width=\"$w\" height=\"$h\" rx=\"10\" ry=\"10\" class=\"sitegroup\"/>\n";
    $record->{'svg'} .= "<text x=\"8\" y=\"20\" font-size=\"16\" class=\"sitegrouplabel\" id=\"sitegroup$id\">$name</text>\n";
    $record->{'svg'} .= "</svg>\n";
  }
  return $records;
}


sub hosts {
  my $self = shift;
  my $records = $self->query('SELECT * FROM hosts');
  return $records;
} 


sub hosts_by_site {
  my $self = shift;
  my $site_id = shift;
  my $records = $self->query('SELECT * FROM hosts WHERE site='.int($site_id));
  foreach my $record (@{$records}) {
    my $id = $record->{'id'};
    my $ip = $record->{'ip'};
    my $name = $record->{'name'};
    # Raw coordinates must be padded
    my $x = $record->{'x'} || 100; 
    my $y = $record->{'y'} || 100;
    $record->{'svg'} .= "<svg x=\"$x\" y=\"$y\" id=\"host$id\" onclick=\"map.host_click(evt, 'host$id');\" onmousedown=\"map.host_mousedown(evt, 'host$id');\" onmouseup=\"map.host_mouseup(evt, 'host$id');\" onmousemove=\"map.host_mousemove(evt, 'host$id');\" onmouseover=\"map.host_mouseover(evt, 'host$id');\" onmouseout=\"map.host_mouseout(evt, 'host$id');\">\n";
    $record->{'svg'} .= "<image x=\"5\" y=\"5\" width=\"40\" height=\"40\" xlink:href=\"/static/PNG/Ukjent.png\" />\n";
    $record->{'svg'} .= "<text x=\"30\" y=\"40\" font-size=\"10\" class=\"symbolbg\">XX</text>\n";
    $record->{'svg'} .= "<text x=\"30\" y=\"40\" font-size=\"10\" class=\"symbol\">XX</text>\n";
    $record->{'svg'} .= "<circle cx=\"25px\" cy=\"25px\" r=\"20px\" class=\"alive\">\n";
    $record->{'svg'} .= "</circle>\n";
    $record->{'svg'} .= "<text x=\"5\" y=\"54.9\" font-size=\"9\">$name</text>\n";
    $record->{'svg'} .= "<text x=\"5\" y=\"63.9\" font-size=\"9\">$ip</text>\n";
    $record->{'svg'} .= "</svg>\n";
  }
  return $records;
} 


sub hostgroups_by_site {
  my $self = shift;
  my $site_id = shift;
  my $records = $self->query("
    SELECT
      MIN(hosts.x) AS x1,
      MIN(hosts.y) AS y1,
      MAX(hosts.x) AS x2,
      MAX(hosts.y) AS y2,
      hostgroups.id,
      hostgroups.name
    FROM hosts
    INNER JOIN hostgroupmembers ON (hostgroupmembers.host = hosts.id)
    LEFT JOIN hostgroups ON (hostgroups.id = hostgroupmembers.hostgroup)
    GROUP BY hostgroups.id
  ");
  foreach my $record (@{$records}) {
    my $id = $record->{'id'};
    my $name = $record->{'name'};
    # Raw coordinates must be padded
    my $x = $record->{'x1'} - 30;
    my $y = $record->{'y1'} - 30;
    my $w = ($record->{'x2'} - $record->{'x1'}) + 110;
    my $h = ($record->{'y2'} - $record->{'y1'}) + 110;
    $record->{'svg'} .= "<svg x=\"$x\" y=\"$y\" width=\"$w\" height=\"$h\" onclick=\"map.hostgroup_click(evt, 'hostgroup$id')\" class=\"hostgroup\" id=\"hostgroup$id\">\n";
    $record->{'svg'} .= "<rect x=\"0\" y=\"0\" width=\"$w\" height=\"$h\" rx=\"10\" ry=\"10\" class=\"hostgroup\"/>\n";
    $record->{'svg'} .= "<text x=\"8\" y=\"20\" font-size=\"16\" class=\"hostgrouplabel\" id=\"hostgroup$id\">$name</text>\n";
    $record->{'svg'} .= "</svg>\n";
  }
  return $records;
}


sub wanlinks {
  my $self = shift;
  my $site_id = shift;
  my $records = $self->query("
    SELECT 
      commlinks.id AS id,
      s1.x AS s1_x,
      s1.y AS s1_y,
      s2.x AS s2_x,
      s2.y AS s2_y
    FROM commlinks
    LEFT JOIN hosts AS h1 ON (h1.id = commlinks.host1)
    LEFT JOIN hosts AS h2 ON (h2.id = commlinks.host2)
    LEFT JOIN sites AS s1 ON (s1.id = h1.site)
    LEFT JOIN sites AS s2 ON (s2.id = h2.site)
    WHERE h1.site != h2.site
  ");
  foreach my $record (@{$records}) {
    my $id = $record->{'id'};
    # Raw coordinates must be padded
    my $x1 = $record->{'s1_x'} + 25;
    my $y1 = $record->{'s1_y'} + 25;
    my $x2 = $record->{'s2_x'} + 25;
    my $y2 = $record->{'s2_y'} + 25;
    # Calculate a bezier control point 10 pixels left off the middle of points 1 and 2
    my $vx = $x2-$x1; my $vy = $y2-$y1;                                     # Vector from point 1 to point 2
    ($vx, $vy) = ($vy, -$vx);                                               # Rotate 90 degrees counter-clockwise
    my $len = sqrt($vx*$vx+$vy*$vy) || 1; $vx=$vx*25/$len; $vy=$vy*25/$len; # Normalize length to 10
    my $qx = $vx + ($x1+$x2)/2; my $qy = $vy + ($y1+$y2)/2;                 # Place vector between points 1 and 2

    $record->{'svg'} .= "<path d=\"M$x1,$y1 Q$qx,$qy $x2,$y2\" class=\"commlink\" id=\"commlink$id\" onclick=\"map.commlink_click(evt, 'commlink$id')\" onmousedown=\"map.commlink_mousedown(evt, 'commlink$id');\" onmouseup=\"map.commlink_mouseup(evt, 'commlink$id');\" onmouseover=\"map.commlink_mouseover(evt, 'commlink$id');\" onmouseout=\"map.commlink_mouseout(evt, 'commlink$id');\" onmousemove=\"map.commlink_mousemove(evt, 'commlink$id');\" />\n";

# Special cases: DSL and GPRS links
#<rect x="1387" y="1945" width="32" height="13" onclick="map.commlink_click(evt, 'commlink727');" 
#onmousedown="map.commlink_mousedown(evt, 'commlink727');" onmouseup="map.commlink_mouseup(evt, 'commlink727');" 
#onmouseover="map.commlink_mouseover(evt, 'commlink727');" onmouseout="map.commlink_mouseout(evt, 'commlink727');" 
#onmousemove="map.commlink_mousemove(evt, 'commlink727');" class="dsl at10m" />
#<text x="1389" y="1955" font-size="10" class="nameplate">DSL</text>

  }
  return $records;
}


sub wanlinks_by_site {
  my $self = shift;
  my $site_id = shift;
  my $records = $self->query("
    SELECT 
      commlinks.id AS id,
      h1.x AS h1_x,
      h1.y AS h1_y,
      s1.x AS s1_x,
      s1.y AS s1_y,
      s1.id AS s1_id,
      h2.x AS h2_x,
      h2.y AS h2_y,
      s2.x AS s2_x,
      s2.y AS s2_y,
      s2.id AS s2_id
    FROM commlinks
    LEFT JOIN hosts AS h1 ON (h1.id = commlinks.host1)
    LEFT JOIN hosts AS h2 ON (h2.id = commlinks.host2)
    LEFT JOIN sites AS s1 ON (s1.id = h1.site)
    LEFT JOIN sites AS s2 ON (s2.id = h2.site)
    WHERE (s1.id = ".int($site_id)." AND s2.id != ".int($site_id).")
    OR (s1.id != ".int($site_id)." AND s2.id = ".int($site_id).")
  ");
  foreach my $record (@{$records}) {
    my $id = $record->{'id'};
    my $name = $record->{'name'};
    # Raw coordinates must be padded
    my ($x1, $y1, $x2, $y2);
    if ($record->{'s1_id'} == $site_id) {
      # Host 1 is local
      $x1 = $record->{'h1_x'} + 25; 
      $y1 = $record->{'h1_y'} + 25; 
      my $dx = $record->{'s2_x'} - $record->{'s1_x'};
      my $dy = $record->{'s2_y'} - $record->{'s1_y'};
      my $len = sqrt($dx*$dx+$dy*$dy) || 1; $dx=$dx*1000/$len; $dy=$dy*1000/$len; # Normalize
      $x2 = $x1 + $dx; 
      $y2 = $y1 + $dy; 
    } else {
      # Host 2 is local
      $x1 = $record->{'h2_x'} + 25; 
      $y1 = $record->{'h2_y'} + 25; 
      my $dx = $record->{'s1_x'} - $record->{'s2_x'};
      my $dy = $record->{'s1_y'} - $record->{'s2_y'};
      my $len = sqrt($dx*$dx+$dy*$dy) || 1; $dx=$dx*$len*1000; $dy=$dy*$len*1000; # Normalize
      $x2 = $x1 + $dx; 
      $y2 = $y1 + $dy; 
    }
    # Calculate a bezier control point 10 pixels left off the middle of points 1 and 2
    my $vx = $x2-$x1; my $vy = $y2-$y1;                                     # Vector from point 1 to point 2
    ($vx, $vy) = ($vy, -$vx);                                               # Rotate 90 degrees counter-clockwise
    my $len = sqrt($vx*$vx+$vy*$vy) || 1; $vx=$vx*25/$len; $vy=$vy*25/$len; # Normalize length to 10
    my $qx = $vx + ($x1+$x2)/2; my $qy = $vy + ($y1+$y2)/2;                 # Place vector between points 1 and 2

    $record->{'svg'} .= "<path d=\"M$x1,$y1 Q$qx,$qy $x2,$y2\" class=\"commlink wan\" id=\"commlink$id\" onclick=\"map.commlink_click(evt, 'commlink$id')\" onmousedown=\"map.commlink_mousedown(evt, 'commlink$id');\" onmouseup=\"map.commlink_mouseup(evt, 'commlink$id');\" onmouseover=\"map.commlink_mouseover(evt, 'commlink$id');\" onmouseout=\"map.commlink_mouseout(evt, 'commlink$id');\" onmousemove=\"map.commlink_mousemove(evt, 'commlink$id');\" />\n";


#<rect x="1387" y="1945" width="32" height="13" onclick="map.commlink_click(evt, 'commlink727');" 
#onmousedown="map.commlink_mousedown(evt, 'commlink727');" onmouseup="map.commlink_mouseup(evt, 'commlink727');" 
#onmouseover="map.commlink_mouseover(evt, 'commlink727');" onmouseout="map.commlink_mouseout(evt, 'commlink727');" 
#onmousemove="map.commlink_mousemove(evt, 'commlink727');" class="dsl at10m" />
#<text x="1389" y="1955" font-size="10" class="nameplate">DSL</text>

  }
  return $records;
}


sub lanlinks_by_site {
  my $self = shift;
  my $site_id = shift;
  my $records = $self->query("
    SELECT 
      commlinks.id AS id,
      h1.x AS h1_x,
      h1.y AS h1_y,
      h2.x AS h2_x,
      h2.y AS h2_y
    FROM commlinks
    LEFT JOIN hosts AS h1 ON (h1.id = commlinks.host1)
    LEFT JOIN hosts AS h2 ON (h2.id = commlinks.host2)
    WHERE h1.site = ".int($site_id)."
    AND h2.site = ".int($site_id)."
  ");
  foreach my $record (@{$records}) {
    my $id = $record->{'id'};
    # Raw coordinates must be padded
    my $x1 = $record->{'h1_x'} + 25;
    my $y1 = $record->{'h1_y'} + 25;
    my $x2 = $record->{'h2_x'} + 25;
    my $y2 = $record->{'h2_y'} + 25;
    # Calculate a bezier control point 10 pixels left off the middle of points 1 and 2
    my $vx = $x2-$x1; my $vy = $y2-$y1;                                     # Vector from point 1 to point 2
    ($vx, $vy) = ($vy, -$vx);                                               # Rotate 90 degrees counter-clockwise
    my $len = sqrt($vx*$vx+$vy*$vy) || 1; $vx=$vx*25/$len; $vy=$vy*25/$len; # Normalize length to 10
    my $qx = $vx + ($x1+$x2)/2; my $qy = $vy + ($y1+$y2)/2;                 # Place vector between points 1 and 2

    $record->{'svg'} .= "<path d=\"M$x1,$y1 Q$qx,$qy $x2,$y2\" class=\"commlink lan\" id=\"commlink$id\" onclick=\"map.commlink_click(evt, 'commlink$id')\" onmousedown=\"map.commlink_mousedown(evt, 'commlink$id');\" onmouseup=\"map.commlink_mouseup(evt, 'commlink$id');\" onmouseover=\"map.commlink_mouseover(evt, 'commlink$id');\" onmouseout=\"map.commlink_mouseout(evt, 'commlink$id');\" onmousemove=\"map.commlink_mousemove(evt, 'commlink$id');\" />\n";


#<line x1="81" y1="72" x2="423.682349502495" y2="2042.42350963935" onclick="map.commlink_click(evt, 'commlink389');" 
#onmousedown="map.commlink_mousedown(evt, 'commlink389');" onmouseup="map.commlink_mouseup(evt, 'commlink389');" 
#onmouseover="map.commlink_mouseover(evt, 'commlink389');" onmouseout="map.commlink_mouseout(evt, 'commlink389');" 
#onmousemove="map.commlink_mousemove(evt, 'commlink389');" class="fiber at1g wan" />
  }
  return $records;
}


sub query {
  my $self = shift;
  my $query = shift;
  
  my $socket = $self->{'session'}->socket;
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
    if ($line =~ /^\@(.+)/) { $cols = $self->{'json'}->decode($1); next; }
    my $row = $self->{'json'}->decode($line);
    my %hash = ();
    @hash{@{$cols}} = @{$row}; 
    push @records, \%hash;
    #warn "$0 $$ hash=".Dumper(\%hash);
  } 
  return \@records;
}


return 1;
