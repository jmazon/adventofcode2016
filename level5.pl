use 5.020;
use warnings;
use Digest::MD5 qw( md5_hex );
my $id = 'uqwqemis';
$|++;
my $part = 2;
my $password = ' ' x 8;
for (my ($i,$c) = (0,0); $c < 8; $i++) {
  my ($a,$b) = md5_hex("$id$i") =~ /^00000(.)(.)/;
  if ( defined $a ) {
    if ( $part == 1 ) {
      print $1;
      $c++;
    }
    elsif ( $part == 2 and $a =~ /^[0-7]$/ and substr($password,$a,1) eq ' ') {
      substr($password,$a,1) = $b;
      say $password;
      $c++;
    }
  }
}
