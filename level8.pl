use 5.020;
use warnings;

my @screen = ('.' x 50) x 6;
while ( <> ) {
  if ( /^rect (\d+)x(\d+)$/ ) {
    for ( 0 .. $2-1 ) {
      substr( $screen[$_], 0, $1 ) = '#' x $1;
    }
  }
  elsif ( /^rotate row y=(\d+) by (\d+)$/ ) {
    my $row = $screen[$1];
    @screen[$1] = substr( $row, -$2 ) . substr( $row, 0, 50 - $2 );
  }
  elsif ( /^rotate column x=(\d+) by (\d+)$/ ) {
    my @col = map substr( $screen[$_], $1, 1 ), 0..5;
    substr( $screen[$_], $1, 1 ) = $col[$_ - $2] for 0..5;
  }
  else { warn "No parse: $_\n" }
}

say for @screen;

my $pixels = 0;
for (@screen) { $pixels++ while /#/g }
say $pixels;
