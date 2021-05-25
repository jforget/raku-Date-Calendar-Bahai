-*- encoding: utf-8; indent-tabs-mode: nil -*-

This sub-directory  contains utility progams used  for developping the
`Date::Calendar::Bahai` module, especially its test files.

gener-tests
===========

This script builds test data to include in `t/05-conversion.rakutest`.
These test data are generated from the Perl module `Date::Converter`.

How to use
----------

Run  the  script  from  the  command line,  redirecting  stdout  to  a
temporary file. Do  not bother with stderr.

Insert the  test data  in `t/05-conversion.rakutest` and  add manually
the commas required for the list values.

gener-week-tests
================

This script helps  building data to check  the week-related attributes
in   Baháʼí   dates  objects.   It   uses   a  partially   implemented
`Date::Calendar::Bahai` module.

First Step
----------

Comment out  then `list(... True)`  lines and uncomment  the `list(...
False)` line.

Run the script.

Check that  the displayed days  of week  correspond to the  real days:
compare with what https://funaba.org/cc gives.

* Jalál → Saturday

* Jamál → Sunday

* Kamál → Monday

* Fiḍál → Tuesday

* ʻIdál → Wednesday

* Istijlál → Thursday

* Istiqlál → Friday

Find the three  cases where the week-year is 53-week  long, and choose
year-intervals  that include  them  and type  these  intervals in  the
`list(... True)`lines.

The three cases are as follows:

* Normal year beginning on Fiḍál (e.g. year 174),

* Leap year beginning on Kamál (e.g. year 168),

* Leap year beginning on Fiḍál (e.g. year 180).

Please note that you have to  read two successive lines, the first one
for  the beginning  of the  year, the  second one  for the  year type:
normal / leap.

Second Step
-----------

Comment out  the `list(...  False)` line  and uncomment  the `list(...
True)` lines.  Update the span  of years in  this line to  include the
samples chosen in the first step.

Run the script, redirecting stdout to a text file.

Edit  this file.  On each  line, update  the `nnnn-Wnn-n`  value. From
right to left:

* Check that the day-of-week is the proper one.

* Change the  week number from "00"  to the proper value,  "01", "02",
  "51, "52" or even "53".

* Change the week-year value by adding or subtracting 1 to the current
value (which has been initialised with the normal year value).

For  number  litterals (month  numbers,  day  numbers and  day-of-year
numbers),  remove  the leading  zeros,  e.g.  replacing "001"  by  "1"
preceded  by two  spaces and  replacing "02"  by "2"  preceded by  one
space.

Insert the resulting source text into `t/07-week.rakutest`.
