use 5.020;
use warnings;
use Digest::MD5 qw( md5_hex );

# my $salt = 'abc';
my $salt = 'ngcjuoqr';
my @found; my $bound;
my %candidates;

++$|;

for ( my $i = 0; $i <= ($bound // $i+1); $i++ ) {
  print "\r$i";
  my $hash = md5_hex("$salt$i");

  # part 2:
  $hash = md5_hex( $hash ) for 1..2016;

  for my $q ( $hash =~ /(.)\1{4}/g ) {
    my @candidates = grep $_ >= $i - 1000, @{$candidates{$q}};
    delete $candidates{$q};
    print "\rCONFIRMED: @candidates\n" if @candidates;
    push @found, @candidates;
    $bound = $i + 1000 if @found >= 64;
  }
  my ($t) = $hash =~ /(.)\1\1/ or next;
  push @{$candidates{$t}}, $i;
  # print "\rCandidate: $i\n";
}
print "\n";

say "@found";
say $found[63];
@found = sort {$a <=> $b} @found;
say $found[63];
