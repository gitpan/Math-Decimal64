use strict;
use warnings;
use Math::Decimal64 qw(:all);

my $t = 17;

print "1..$t\n";

my $rop = Math::Decimal64->new();

assignPV($rop, 'inf');

if(is_InfD64($rop) == 1) {print "ok 1\n"}
else {
  warn "Inf: $rop\n";
  print "not ok 1\n";
}

assignPV($rop, '-inf');

if(is_InfD64($rop) == -1) {print "ok 2\n"}
else {
  warn "-Inf: $rop\n";
  print "not ok 2\n";
}

assignPV($rop, '+inf');

if(is_InfD64($rop) == 1) {print "ok 3\n"}
else {
  warn "+Inf: $rop\n";
  print "not ok 3\n";
}

# Space for 2 tests here.
print "ok 4\nok 5\n";

assignPV($rop, 'nan');

if(is_NaND64($rop)) {print "ok 6\n"}
else {
  warn "NaN: $rop\n";
  print "not ok 6\n";
}

assignPV($rop, '+nan');

if(is_NaND64($rop)) {print "ok 7\n"}
else {
  warn "+NaN: $rop\n";
  print "not ok 7\n";
}

assignPV($rop, '-nan');

if(is_NaND64($rop)) {print "ok 8\n"}
else {
  warn "-NaN: $rop\n";
  print "not ok 8\n";
}

if($rop != NaND64()) {print "ok 9\n"}
else {
  warn "$rop == ", NaND64(), "\n";
  print "not ok 9\n";
}

my $ok = 1;

for my $exp(0..10, 20, 30, 350 .. 430) {
  for my $digits(1..16) {
    my $man = '-' . random_select($digits);
    my $d64 = MEtoD64($man, -$exp);
    assignPV($rop, $man . 'e' . -$exp);
    #my $check = PVtoD64($man . 'e' . -$exp);
    if($rop != $d64) {
      $ok = 0;
      warn "\n  (man, exp): ($man, $exp)\n";
      warn "  MEtoD64: $d64\n  PVtoD64: $rop\n";
    }
  }
}

$ok ? print "ok 10\n" : print "not ok 10\n";

$ok = 1;

for my $exp(0..10, 20, 30, 350 .. 430) {
  for my $digits(1..16) {
    my $man = random_select($digits);
    my $d64 = MEtoD64($man, $exp);
    assignPV($rop, $man . 'E' . $exp);
    #my $check = PVtoD64($man . 'E' . $exp);
    if($rop != $d64) {
      $ok = 0;
      warn "\n  (man, exp): ($man, $exp)\n";
      warn "  MEtoD64: $d64\n  PVtoD64: $rop\n";
    }
  }
}

$ok ? print "ok 11\n" : print "not ok 11\n";

$ok = 1;

for my $exp(0..10, 20, 30, 350 .. 430) {
  for my $digits(1..16) {
    my $man = '-' . random_select($digits);
    my $d64 = MEtoD64($man, $exp);
    assignPV($rop, $man . 'E' . $exp);
    #my $check = PVtoD64($man . 'E' . $exp);
    if($rop != $d64) {
      $ok = 0;
      warn "\n  (man, exp): ($man, $exp)\n";
      warn "  MEtoD64: $d64\n  PVtoD64: $rop\n";
    }
  }
}

$ok ? print "ok 12\n" : print "not ok 12\n";

$ok = 1;

for my $exp(0..10, 20, 30, 350 .. 430) {
  for my $digits(1..16) {
    my $man = random_select($digits);
    my $d64 = MEtoD64($man, -$exp);
    assignPV($rop, $man . 'e' . -$exp);
    #my $check = PVtoD64($man . 'e' . -$exp);
    if($rop != $d64) {
      $ok = 0;
      warn "\n  (man, exp): ($man, $exp)\n";
      warn "  MEtoD64: $d64\n  PVtoD64: $rop\n";
    }
  }
}

$ok ? print "ok 13\n" : print "not ok 13\n";

$ok = 1;

for my $exp(0..10, 20, 30, 350 .. 430) {
  for my $digits(1..16) {
    my $man = '-' . random_select($digits);
    my $d64 = MEtoD64($man, -$exp);
    my $mod = me2pv($man, -$exp);
    assignPV($rop, $mod);
    #my $check = PVtoD64($mod);
    if($rop != $d64) {
      $ok = 0;
      warn "\n  (man, exp): ($man, $exp)\n";
      warn "  MEtoD64: $d64\n  PVtoD64: $rop\n";
    }
  }
}

$ok ? print "ok 14\n" : print "not ok 14\n";

$ok = 1;

for my $exp(0..10, 20, 30, 350 .. 430) {
  for my $digits(1..16) {
    my $man = random_select($digits);
    my $d64 = MEtoD64($man, $exp);
    my $mod = me2pv($man, $exp);
    assignPV($rop, $mod);
    #my $check = PVtoD64($mod);
    if($rop != $d64) {
      $ok = 0;
      warn "\n  (man, exp): ($man, $exp)\n";
      warn "  MEtoD64: $d64\n  PVtoD64: $rop\n";
    }
  }
}

$ok ? print "ok 15\n" : print "not ok 15\n";

$ok = 1;

for my $exp(0..10, 20, 30, 350 .. 430) {
  for my $digits(1..16) {
    my $man = '-' . random_select($digits);
    my $d64 = MEtoD64($man, $exp);
    my $mod = me2pv($man, $exp);
    assignPV($rop, $mod);
    #my $check = PVtoD64($mod);
    if($rop != $d64) {
      $ok = 0;
      warn "\n  (man, exp): ($man, $exp)\n";
      warn "  MEtoD64: $d64\n  PVtoD64: $rop\n";
    }
  }
}

$ok ? print "ok 16\n" : print "not ok 16\n";

$ok = 1;

for my $exp(0..10, 20, 30, 350 .. 430) {
  for my $digits(1..16) {
    my $man = random_select($digits);
    my $d64 = MEtoD64($man, -$exp);
    my $mod = me2pv($man, -$exp);
    assignPV($rop, $mod);
    #my $check = PVtoD64($mod);
    if($rop != $d64) {
      $ok = 0;
      warn "\n  (man, exp): ($man, $exp)\n";
      warn "  MEtoD64: $d64\n  PVtoD64: $rop\n";
    }
  }
}

$ok ? print "ok 17\n" : print "not ok 17\n";

sub random_select {
  my $ret = '';
  for(1 .. $_[0]) {
    $ret .= int(rand(10));
  }
  return "$ret";
}

sub me2pv {
  my($man, $exp) = (shift, shift);
  my $sign = '';
  if($man =~ /[^0-9]/) {
    $sign = substr($man, 0, 1);
    $man = substr($man, 1);
  }
  my $len = length($man);
  my $pos = int(rand($len + 1));
  my $insert;
  if($pos == $len) {$insert = '.0'}
  elsif($pos == 0 && $len % 2) {$insert = '0.'}
  else {$insert = '.'}
  substr($man, $pos, 0, $insert);
  $exp += $len - $pos;
  my $ret = $sign . $man . 'e' . $exp;
  #print "$ret\n";
  return $ret;
}
