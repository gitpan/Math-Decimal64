use strict;
use warnings;
use Math::Decimal64 qw(:all);

my $t = 10;

print "1..$t\n";

my $fmt = d64_fmt();

if($fmt eq 'DPD' || $fmt eq 'BID') {
  warn "\nDetected $fmt formatting\n";
  print "ok 1\n";
}
else {
  warn "\nDetected $fmt formatting\n";
  print "not ok 1\n";
}

my $inf = MEtoD64('1', 0) / ZeroD64(1);

my $dec = decode_d64($inf);
if($dec eq 'inf') {print "ok 2\n"}
else {
  warn "\n\$dec: $dec\n";
  print "not ok 2\n";
}

$inf *= UnityD64(-1);
$dec = decode_d64($inf);
if($dec eq '-inf') {print "ok 3\n"}
else {
  warn "\n\$dec: $dec\n";
  print "not ok 3\n";
}

$inf -= $inf;
$dec = decode_d64($inf);
if($dec eq 'nan') {print "ok 4\n"}
else {
  warn "\n\$dec: $dec\n";
  print "not ok 4\n";
}

my $ok = 1;

for my $exp(0..10, 20, 30, 280 .. 300) {
  for my $digits(1..16) {
    my $man = random_select($digits);
    my $d64 = MEtoD64($man, $exp);
    my $str = decode_d64($d64);
    my @redo = split /e/, $str;
    #$redo[0] =~ s/^\+//;
    my $check = MEtoD64($redo[0], $redo[1]);
    if($check != $d64) {
      $ok = 0;
      my @check = D64toME($check);
      warn "\n ($man, $exp) != ($check[0], $check[1])\n";
    }
  }
}

$ok ? print "ok 5\n" : print "not ok 5\n";

$ok = 1;

for my $exp(0..10, 20, 30, 280 .. 300) {
  for my $digits(1..16) {
    my $man = '-' . random_select($digits);
    my $d64 = MEtoD64($man, $exp);
    my $str = decode_d64($d64);
    my @redo = split /e/, $str;
    #$redo[0] =~ s/^\+//;
    my $check = MEtoD64($redo[0], $redo[1]);
    if($check != $d64) {
      $ok = 0;
      my @check = D64toME($check);
      warn "\n ($man, $exp) != ($check[0], $check[1])\n";
    }
  }
}

$ok ? print "ok 6\n" : print "not ok 6\n";

$ok = 1;

for my $exp(0..10, 20, 30, 280 .. 300) {
  for my $digits(1..16) {
    my $man = random_select($digits);
    my $d64 = MEtoD64($man, -$exp);
    my $str = decode_d64($d64);
    my @redo = split /e/, $str;
    #$redo[0] =~ s/^\+//;
    my $check = MEtoD64($redo[0], $redo[1]);
    if($check != $d64) {
      $ok = 0;
      my @check = D64toME($check);
      warn "\n ($man, $exp) != ($check[0], $check[1])\n";
    }
  }
}

$ok ? print "ok 7\n" : print "not ok 7\n";

$ok = 1;

for my $exp(0..10, 20, 30, 280 .. 300) {
  for my $digits(1..16) {
    my $man = '-' . random_select($digits);
    my $d64 = MEtoD64($man, -$exp);
    my $str = decode_d64($d64);
    my @redo = split /e/, $str;
    #$redo[0] =~ s/^\+//;
    my $check = MEtoD64($redo[0], $redo[1]);
    if($check != $d64) {
      $ok = 0;
      my @check = D64toME($check);
      warn "\n ($man, $exp) != ($check[0], $check[1])\n";
    }
  }
}

$ok ? print "ok 8\n" : print "not ok 8\n";

my $d64 = MEtoD64('000200', 200);

$dec = decode_d64($d64);

if($dec eq '2e202') {print "ok 9\n"}
else {
  warn "\n9: \$dec: $dec\n";
  print "not ok 9\n";
}

$d64 *= UnityD64(-1);

$dec = decode_d64($d64);

if($dec eq '-2e202') {print "ok 10\n"}
else {
  warn "\n10: \$dec: $dec\n";
  print "not ok 10\n";
}

sub random_select {
  my $ret = '';
  for(1 .. $_[0]) {
    $ret .= int(rand(10));
  }
  return "$ret";
}
