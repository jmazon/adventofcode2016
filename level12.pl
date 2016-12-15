use 5.020;
use warnings;

my $i = 0;
my $prog = 'my (a,b,c,d) = (0,0,C,0);';
while ( <> ) {
  chomp;
  s/cpy (\S+) (.)/$2 = $1/;
  s/inc (.)/$1++/;
  s/dec (.)/$1--/;
  s/jnz (.) (\S+)/ "$1 == 0 or goto LBL" . ($i + $2)/e;
  $prog .= "LBL$i: $_;";
  $i++;
}
$prog .= "LBL$i: a;";
$prog =~ s/\b[abcd]\b/\$$&/g;

# part 1:
# $prog =~ s/C/0/;
# part 2:
$prog =~ s/C/1/;

print $prog =~ s/;/\n/gr;
say eval $prog;

__DATA__
cpy 41 a
inc a
inc a
dec a
jnz a 2
dec a
