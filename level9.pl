use 5.020;
use warnings;

$_ = <>;
chomp;

sub expand {
  my $expr = shift;
  my $length = 0;
  while ( $expr =~ s/^(.*?)\((\d+)x(\d+)\)// ) {
    $length += length $1;
    my $substring = substr($expr, 0, $2, '');
    my $repeat = $3;
    $length += $repeat * expand( $substring );
  }
  return $length + length $expr;
}

if (0) {
  while ( s/(.*?)\((\d+)x(\d+)\)// ) {
    print $1, substr($', 0, $2) x $3;
    s/.{$2}//;
  }
  say;
}
else {
  say expand($_);
}
