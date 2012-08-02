use warnings;
use strict;
use Math::Decimal64 qw(:all);
use Math::BigInt;

print "1..6\n";

my $x = Math::Decimal64->new();
my $badarg1 = 17;
my $badarg2 = Math::BigInt->new();

if(is_NaND64($x) && !$x && $x != $x) {print "ok 1\n"}
else {
  warn "\$x: $x\n";
  print "not ok 1\n";
}

assignME($x, 1623, -3);
if($x == Math::Decimal64->new(1623, -3)) {print "ok 2\n"}
else {
  warn "\$x: $x\n";
  print "not ok 2\n";
}

assignME($x, 1623, 0);
if($x == Math::Decimal64->new(1623, 0)) {print "ok 3\n"}
else {
  warn "\$x: $x\n";
  print "not ok 3\n";
}

assignME($x, 1623, 2);
if($x == Math::Decimal64->new(162300)) {print "ok 4\n"}
else {
  warn "\$x: $x\n";
  print "not ok 4\n";
}

eval {assignME($badarg1, 15, -5);};
if($@ =~ /Invalid argument supplied to Math::Decimal64::assignME function/) {print "ok 5\n"}
else {
  warn "\$\@: $@\n";
  print "not ok 5\n";
}

eval {assignME($badarg2, 15, -5);};
if($@ =~ /Invalid object supplied to Math::Decimal64::assignME function/) {print "ok 6\n"}
else {
  warn "\$\@: $@\n";
  print "not ok 6\n";
}

