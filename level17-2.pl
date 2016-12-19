use 5.020;
use warnings;
use Digest::MD5 qw(md5_hex);

sub is_open { shift =~ /^[b-f]$/ }

my $prefix = 'gdjjyniy';
my @stack = [ 0, 0, '' ];
my $best = 0;

while ( @stack ) {
  my ($x,$y,$path) = @{ pop @stack };
  if ( $x == 3 and $y == 3 ) {
    length $path > $best and $best = length $path;
    next;
  }
  my ($up,$down,$left,$right) = md5_hex( "$prefix$path" ) =~ /^(.)(.)(.)(.)/;

  $y > 0 and is_open(    $up ) and push @stack, [ $x, $y-1, "${path}U" ];
  $y < 3 and is_open(  $down ) and push @stack, [ $x, $y+1, "${path}D" ];
  $x > 0 and is_open(  $left ) and push @stack, [ $x-1, $y, "${path}L" ];
  $x < 3 and is_open( $right ) and push @stack, [ $x+1, $y, "${path}R" ];
}

say $best;
