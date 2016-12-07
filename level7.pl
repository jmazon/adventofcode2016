use 5.020;
use warnings;

my $tls_count = 0;
my $ssl_count = 0;

while (<>) {
  my $hs = join '-', /\[([^]]*)\]/g;
  s/\[([^]]*)\]/-/g;
  my $outside = /(.)((?!\1).)\2\1/;
  my $inside = $hs =~ /(.)((?!\1).)\2\1/;
  $tls_count++ if $outside and not $inside;

  while ( /(.)((?!\1).)\1/g ) {
    $ssl_count++, last if index( $hs, $bab ) >= 0;
    pos() -= 2;
  }
}

say "$tls_count TLS";
say "$ssl_count SSL";
