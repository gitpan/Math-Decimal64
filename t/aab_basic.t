use warnings;
use strict;
use Math::Decimal64 qw(:all);

print "1..1\n";


if($Math::Decimal64::VERSION eq '0.06' && Math::Decimal64::_get_xs_version() eq $Math::Decimal64::VERSION) {print "ok 1\n"}
else {print "not ok 1 $Math::Decimal64::VERSION ", Math::Decimal64::_get_xs_version(), "\n"}

