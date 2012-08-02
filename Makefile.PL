use ExtUtils::MakeMaker;

use Config;
use 5.006;

$defines = $] < 5.008 ? "-DOLDPERL" : "-DNEWPERL";

# If you have the strtod64() function, set $strtold64 to 1. (You might then
# also have to add the appropriate header to the #includes in Decimal64.xs.)
$strtod64 = 0;
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
