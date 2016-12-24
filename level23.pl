#! /usr/bin/env perl
use 5.020;
use warnings;

# my $eggs = 7;
my $eggs = 12;

my (@code,@orig);
my %ops = ( cpy => [1, 0],
            inc => [0, 1],
            dec => [1, 1],
            jnz => [0, 0],
            tgl => [2, 1],
            mul => [3, 1],
            nop => [4, 1] );

while ( <DATA> ) {
  chomp;
  push @orig, $_;
  my @words = split ' ', $_;
  my @row;
  push @row, @{ $ops{shift @words} };
  for (@words) {
    s/[abcd]/\$$&/;
    push @row, $_;
  }
  push @code, \@row;
}

my ($a,$b,$c,$d) = ($eggs,0,0,0);
my $ip = 0;
my $size = @code;
while ($ip < $size) {
  my $code = $code[$ip][0] + 3*$code[$ip][1];
  my $op;
  if ( $code == 1 ) {
    $op = "$code[$ip][3] = $code[$ip][2]";
  }
  elsif ( $code == 3 ) {
    $op = "$code[$ip][2]++";
  }
  elsif ( $code == 4 ) {
    $op = "$code[$ip][2]--";
  }
  elsif ( $code == 0 ) {
    $op = "\$ip += $code[$ip][3] - 1 if $code[$ip][2] != 0";
  }
  elsif ( $code == 5 ) {
    $op = "my \$target = \$ip + $code[$ip][2]; \$code[\$target][0] = 0+ !\$code[\$target][0]";
  }
  elsif ( $code == 6 ) {
    $op = "$code[$ip][4] = $code[$ip][2] * $code[$ip][3]";
  }
  elsif ( $code == 7 ) {
    $op = '';
  }
  else { die "Unknown code $code" }
  say "$a $b $c $d ($ip) $orig[$ip]\t$op";
  eval $op;
  $ip++;
}
say "$a $b $c $d $ip";

__DATA__
cpy a b
dec b
cpy a d
mul d b a # cpy 0 a
cpy 0 c   # cpy b c
cpy 0 d   # inc a
nop       # dec c
nop       # jnz c -2
nop       # dec d
nop       # jnz d -5
dec b
mul 2 b c # cpy b c
cpy 0 d   # cpy c d
nop       # dec d
nop       # inc c
nop       # jnz d -2
tgl c
cpy -16 c
jnz 1 c
cpy 71 c
jnz 75 d
inc a
inc d
jnz d -2
inc c
jnz c -5
