use 5.020;
use warnings;

$_ = <>;

while ( s/(.*?)\((\d+)x(\d+)\)// ) {
  print $1, substr($', 0, $2) x $3;
  s/.{$2}//;
}
print;
