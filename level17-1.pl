use 5.020;
use warnings;
use Digest::MD5 qw(md5_hex);

sub is_open { shift =~ /^[b-f]$/ }

my $prefix = 'gdjjyniy';
my @queue = [ 0, 0, '' ];

while ( @queue ) {
  my ($x,$y,$path) = @{ shift @queue };

  if ( $x == 3 and $y == 3 ) {
    say $path;
    exit;
  }
  my $hash = md5_hex( "$prefix$path" );
  my ($up,$down,$left,$right) = $hash =~ /^(.)(.)(.)(.)/;

  $y > 0 and is_open(    $up ) and push @queue, [ $x, $y-1, "${path}U" ];
  $y < 3 and is_open(  $down ) and push @queue, [ $x, $y+1, "${path}D" ];
  $x > 0 and is_open(  $left ) and push @queue, [ $x-1, $y, "${path}L" ];
  $x < 3 and is_open( $right ) and push @queue, [ $x+1, $y, "${path}R" ];
}

die "Exhausted";
