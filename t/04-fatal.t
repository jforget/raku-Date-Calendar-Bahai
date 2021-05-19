#
# Checking the checks at build time
#
use v6.c;
use Test;
use Date::Calendar::Bahai;
use Date::Calendar::Bahai::Astronomical;

# Data based on the https://bahai-library.com/pdf/uhj/uhj_badi_calendar_2014.pdf document
# (see https://bahai-library.com/uhj_badi_calendar_2014)
my @lives = ((172,  1,  1, "correct")
           , (181,  1, 19, "correct")
           , (194, 18,  1, "correct")
           , (204, 18, 19, "correct")
           , (213, 20,  1, "correct")
           , (221, 20, 19, "correct")
           , (192, 19,  4, "correct additional day on a normal year")
           , (168, 19,  5, "leap day before the 2015 reform")
           , (216, 19,  5, "leap day common to arithmetic and astronomical")
           , (220, 19,  5, "leap day common to arithmetic and astronomical")
             );
my @dies  = ((175,  1,  0, "day out of range")
           , (179,  1, 20, "day out of range")
           , (183, 20,  0, "day out of range")
           , (191, 20, 20, "day out of range")
           , (197,  0,  1, "month out of range")
           , (202, 21,  1, "month out of range")
           , (205, 19,  0, "additional day out of range")
           , (216, 19,  6, "additional day out of range on a leap year")
           , (214, 19,  5, "additional day out of range on a normal year")
             );

# Arithmetic dies, astronomical lives
my @dies-arit = ((174, 19, 5, "first astronomical leap day after the 2015 reform")
               , (211, 19, 5, "second last known difference between arithmetic and astronomical")
               );

# Astronomical dies, arithmetic lives
my @dies-astr = ((172, 19, 5, "leap day")
               , (192, 19, 5, "leap day")
               , (212, 19, 5, "last known difference between arithmetic and astronomical")
               );

plan 2 × (@lives.elems + @dies.elems + @dies-arit.elems + @dies-astr.elems);

my Date::Calendar::Bahai $d-fr;

for (|@lives, |@dies-astr) -> $test {
  my ($y, $m, $d, $text) = $test;
  $text = sprintf("%04d-%02d-%02d arithmetic lives %s", $y, $m, $d, $text);
  lives-ok( {$d-fr .= new(year => $y, month => $m, day => $d) }, $text);
}

for (|@dies, |@dies-arit) -> $test {
  my ($y, $m, $d, $text) = $test;
  $text = sprintf("%04d-%02d-%02d arithmetic dies %s", $y, $m, $d, $text);
  dies-ok( {$d-fr .= new(year => $y, month => $m, day => $d) }, $text);
}

my Date::Calendar::Bahai::Astronomical $d-ast;

for (|@lives, |@dies-arit) -> $test {
  my ($y, $m, $d, $text) = $test;
  $text = sprintf("%04d-%02d-%02d astronomical lives %s", $y, $m, $d, $text);
  lives-ok( {$d-ast .= new(year => $y, month => $m, day => $d) }, $text);
}

for (|@dies, |@dies-astr) -> $test {
  my ($y, $m, $d, $text) = $test;
  $text = sprintf("%04d-%02d-%02d astronomical dies %s", $y, $m, $d, $text);
  dies-ok( {$d-ast .= new(year => $y, month => $m, day => $d) }, $text);
}

done-testing;
