use ExtUtils::MakeMaker;

use Config;
use 5.006;

$defines = $] < 5.008 ? "-DOLDPERL" : "-DNEWPERL";

# If you have the strtod64() function, either set $strtold64 to 1 or provide
# STRTOD64=1 as a command line argument to the Makefile.PL. (You might then
# also have to add the appropriate header to the #includes in Decimal64.xs.)
$strtod64 = 0;
for(@ARGV) {
  $strtod64 = 1 if $_ eq 'STRTOD64=1';
}
$defines .= " -DSTRTOD64_AVAILABLE" if $strtod64;

my %options = %{
{
  'NAME' => 'Math::Decimal64',
  'DEFINE' => $defines,
  'LIBS' => [
    '-lm'
  ],
  'INC' => '',
  'VERSION_FROM' => 'Decimal64.pm'
}
};
WriteMakefile(%options);

# Remove the Makefile dependency. Causes problems on a few systems.
sub MY::makefile { '' }