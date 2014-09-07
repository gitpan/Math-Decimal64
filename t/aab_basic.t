use warnings;
use strict;
use Math::Decimal64 qw(:all);

print "1..2\n";


if($Math::Decimal64::VERSION eq '0.07' && Math::Decimal64::_get_xs_version() eq $Math::Decimal64::VERSION) {print "ok 1\n"}
else {print "not ok 1 $Math::Decimal64::VERSION ", Math::Decimal64::_get_xs_version(), "\n"}

my $end = Math::Decimal64::_endianness();

if(defined($end)) {
  warn "\nEndianness: $end\n";
  print "ok 2\n";
}
else {
  print "not ok 2\n";
}
