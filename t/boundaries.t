use warnings;
use strict;
use Math::Decimal64 qw(:all);

print "1..18\n";

my($man, $exp);

my $minus_one = Math::Decimal64->new(-1, 0);

my $max = Math::Decimal64->new('9999999999999999', 369);

if(!is_InfD64($max)) {print "ok 1\n"}
else {
  warn "\n\$max: $max\n";
  print "not ok 1\n";
}

my $min = Math::Decimal64->new('-9999999999999999', 369);

if(!is_InfD64($min)) {print "ok 2\n"}
else {
  warn "\n\$min: $min\n";
  print "not ok 2\n";
}

if($max * $minus_one == $min && -$max == $min && -$min == $max) {print "ok 3\n"}
else {print "not ok 3\n"}

($man, $exp) = D64toME($max);

if($man eq '9999999999999999' && $exp == 369) {print "ok 4\n"}
else {
  warn "\$man: $man\n\$exp: $exp\n";
  print "not ok 4\n";
}

($man, $exp) = D64toME($min);

if($man eq '-9999999999999999' && $exp == 369) {print "ok 5\n"}
else {
  warn "\$man: $man\n\$exp: $exp\n";
  print "not ok 5\n";
}

my $smallest_pos = Math::Decimal64->new(1, -398);
($man, $exp) = D64toME($smallest_pos);

if($man == 1 && $exp == -398){print "ok 6\n"}
else {
  warn "\$man: $man\n\$exp: $exp\n";
  print "not ok 6\n";
}

my $biggest_neg = Math::Decimal64->new(-1, -398);
($man, $exp) = D64toME($biggest_neg);

if($man == -1 && $exp == -398){print "ok 7\n"}
else {
  warn "\$man: $man\n\$exp: $exp\n";
  print "not ok 7\n";
}

my $zero = Math::Decimal64->new(0, 0);

if(is_ZeroD64($zero) > 0) {print "ok 8\n"}
else {print "not ok 8\n"}

($man, $exp) = D64toME($zero);

if($man eq '0' && $exp eq '0'){print "ok 9\n"}
else {
  warn "\$man: $man\n\$exp: $exp\n";
  print "not ok 9\n";
}

$zero *= $minus_one;

if(is_ZeroD64($zero) < 0) {print "ok 10\n"}
else {print "not ok 10\n"}

($man, $exp) = D64toME($zero);

if($man eq '-0' && $exp eq '0'){print "ok 11\n"}
else {
  warn "\$man: $man\n\$exp: $exp\n";
  print "not ok 11\n";
}

my $pos_test = Math::Decimal64::_testvalD64(1);
my $neg_test = Math::Decimal64::_testvalD64(-1);

($man, $exp) = D64toME($pos_test);
if($man eq '9307199254740993' && $exp == -15) {print "ok 12\n"}
else {print "not ok 12\n"}


($man, $exp) = D64toME($neg_test);
if($man eq '-9307199254740993' && $exp == -15) {print "ok 13\n"}
else {print "not ok 13\n"}

my $pos_check = Math::Decimal64->new('9307199254740993', -15);
if($pos_check == $pos_test) {print "ok 14\n"}
else {
  warn "\$pos_check: $pos_check\n";
  print "not ok 14\n";
}

my $neg_check = Math::Decimal64->new('-9307199254740993', -15);
if($neg_check == $neg_test) {print "ok 15\n"}
else {
  warn "\$neg_check: $neg_check\n";
  print "not ok 15\n";
}

my $pv_check = PVtoD64('-9307199254740993e-15');

if($pv_check == $neg_test) {print "ok 16\n"}
else {
 warn "\$pv_check: $pv_check\n";
 print "not ok 16\n";
}

my $shift = Exp10(-15);
my $cancel = Exp10(15);

if($shift * $cancel == UnityD64(1)){print "ok 17\n"}
else {
  warn "\$shift: $shift \$cancel: $cancel\n";
  print "not ok 17\n";
}

my $pv_check2 = PVtoD64('-9307199254740993');
$pv_check2 *= $shift;

if($pv_check2 == $neg_test) {print "ok 18\n"}
else {
 warn "\$pv_check2: $pv_check2\n";
 print "not ok 18\n";
}
