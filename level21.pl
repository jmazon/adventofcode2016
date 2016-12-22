#! /usr/bin/env perl

use 5.020;
use warnings;

my $buf;
my $part = 2;
if ( $part == 1 ) { $buf = 'abcdefgh' }
elsif ( $part == 2 ) { $buf = 'fbgdceah' }

while ( <> ) {
  say $buf;
  print;
  if ( my ($sp1,$sp2) = /^swap position (\d+) with position (\d+)$/ ) {
    (substr($buf,$sp1,1),substr($buf,$sp2,1)) = (substr($buf,$sp2,1),substr($buf,$sp1,1));
  }
  elsif ( my ($sl1,$sl2) = /^swap letter (\w) with letter (\w)$/ ) {
    $buf =~ s/$sl1/#/g;
    $buf =~ s/$sl2/$sl1/g;
    $buf =~ s/#/$sl2/g;
  }
  elsif ( my ($rp1,$rp2) = /^reverse positions (\d+) through (\d+)$/ ) {
    my $l = $rp2 - $rp1 + 1;
    substr($buf, $rp1, $l) = reverse substr($buf, $rp1, $l);
  }
  elsif ( my ($dir,$steps) = /^rotate (left|right) (\d+) steps?$/ ) {
    if ( $part == 2 ) {
      $dir = $dir eq 'left' ? 'right' : $dir eq 'right' ? 'left' : $dir;
    }
    if ( $steps ) {
      if ($dir eq 'left') {
        $buf = substr( $buf, 1 ) . substr( $buf, 0, 1) for 1 .. $steps;
      }
      elsif ( $dir eq 'right' ) {
        $buf = substr( $buf, -1 ) . substr( $buf, 0, length($buf)-1 ) for 1 .. $steps;
      }
      else { die "Bad dir $dir" }
    }
  }
  elsif ( my ($mp1,$mp2) = /^move position (\d+) to position (\d+)$/ ) {
    ($mp1,$mp2) = ($mp2,$mp1) if $part == 2;
    my $l = substr($buf, $mp1, 1, '');
    substr($buf, $mp2, 0, $l);
  }
  elsif ( my ($l) = /^rotate based on position of letter (\w)$/ ) {
    my $p = index $buf, $l;
    if ( $part == 1 ) {
      $p++ if $p >= 4;
      $p++;
      if ($p) {
        $buf = substr( $buf, -1 ) . substr( $buf, 0, length($buf)-1 ) for 1..$p;
      }
    }
    elsif ( $part == 2 ) {
      $p = (1,1,6,2,7,3,0,4)[$p];
      $buf = substr( $buf, $p ) . substr( $buf, 0, $p );
    }
    else { die "Bad part $part" }
  }
  else { die "Bad op $_" }
}
say $buf;
