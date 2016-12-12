use 5.020;
use warnings;

say '# This Makefile is generated';
say "# See $0 for details";
say 'all:';
say 'clean: ; rm bot-* value-* output-*';

my $value = 0;
my %output;
while ( <> ) {
  if ( /^value (\d+) goes to bot (\d+)$/ ) {
    say "value-$value: ; echo $1 > \$\@";
    say "bot-$2: value-$value";
    $value++;
  }
  elsif ( my ($bot,$low,$high) =
          /^bot (\d+) gives low to ((?:bot|output) \d+) and high to ((?:bot|output) \d+)$/ ) {
    $bot = "bot-$bot";
    $low =~ tr/ /-/;
    $high =~ tr/ /-/;
    say "$bot: ; cat \$\^ > \$\@";
    say "$bot-low: $bot ; sort -n \$\< | head -1 > \$\@";
    say "$bot-high: $bot ; sort -n \$\< | tail -1 > \$\@";
    say "$low: $bot-low";
    say "$high: $bot-high";
    say "all: $bot";
    $low =~ /^output/ and $output{$low}++;
    $high =~ /^output/ and $output{$high}++;
  }
  else { die "No parse: $_" }
}
say "$_: ; cat \$\^ > \$\@" for keys %output;

say 'part-one: all; grep -lx 61 bot-* | xargs grep -lx 17';
say 'part-two: output-0 output-1 output-2 ; echo `cat $^` | tr " " "*" | bc';

__DATA__
value 5 goes to bot 2
bot 2 gives low to bot 1 and high to bot 0
value 3 goes to bot 1
bot 1 gives low to output 1 and high to bot 0
bot 0 gives low to output 2 and high to output 0
value 2 goes to bot 2
