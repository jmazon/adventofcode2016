#! /usr/bin/env perl
use 5.020;
use warnings;

<>;
<>;
my ($X,$Y,%grid) = (0,0);
while (<>) {
  my @fields = split /\s+/, $_;
  my ($x,$y) = $fields[0] =~ /-x(\d+)-y(\d+)/;
  $X = $x if $x > $X;
  $Y = $y if $y > $Y;
  s/T$// for @fields[2,3];
  my ($used,$free) = @fields[2,3];
  $grid{$x,$y} = $used == 0 ? '_' : $used > 100 ? '#' : '.';
}
$grid{$X,0} = 'G';
for my $y (0..$Y) {
  for my $x (0..$X) {
    print $grid{$x,$y};
  }
  print "\n";
}
__DATA__
6l
6u
22r
35*5l
__END__
....................................G
.....................................
...............######################
.....................................
.....................................
.....................................
...................._................
.....................................
.....................................
.....................................
.....................................
.....................................
.....................................
.....................................
.....................................
.....................................
.....................................
.....................................
.....................................
.....................................
.....................................
.....................................
.....................................
.....................................
.....................................
.....................................
.....................................