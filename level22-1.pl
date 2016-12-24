#! /usr/bin/env perl
use 5.020;
use warnings;

<>;
<>;
my (@used,@free);
while (<>) {
  my @fields = split /\s+/, $_;
  s/T$// for @fields[2,3];
  push @used, $fields[2];
  push @free, $fields[3];
}
my $viable = 0;
for my $u (0 .. $#used) {
  for my $f (0 .. $#free) {
    $u != $f or next;
    $used[$u] > 0 or next;
    $free[$f] >= $used[$u] or next;
    $viable++;
  }
}
say $viable;
