# main.raku

use v6.d;
use lib './lib';
use Syntax;

my $combodir = "./examples/";
my $comboext = ".combo";

# Name of the input file
my $input = "simple_test";

my $filename = $combodir ~ $input ~ $comboext;
my $contents = $filename.IO.slurp;
say Syntax::Parser.parse($contents);
