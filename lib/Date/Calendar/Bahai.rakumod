# -*- encoding: utf-8; indent-tabs-mode: nil -*-

use Date::Calendar::Strftime;
use Date::Calendar::Bahai::Names;
use Date::Calendar::Bahai::Common;

unit class Date::Calendar::Bahai:ver<0.0.1>:auth<cpan:JFORGET>
      does Date::Calendar::Bahai::Common
      does Date::Calendar::Strftime;

multi method BUILD(Int:D :$year, Int:D :$month, Int:D :$day, Str :$locale = 'ar') {
  self!check-build-args1($year, $month, $day, $locale);
  self!build-from-args1( $year, $month, $day, $locale);
}

multi method BUILD(Int:D :$major-cycle, Int:D :$cycle, Int:D :$cycle-year
                 , Int:D :$month,       Int:D :$day,   Str   :$locale = 'ar') {
  self!check-build-args2($major-cycle, $cycle, $cycle-year, $month, $day, $locale);
  self!build-from-args2( $major-cycle, $cycle, $cycle-year, $month, $day, $locale);
}

# If $bahai-year is given, gives the March day number of Naw-Rúz for the given year.
# If $bahai-year is omitted, gives the March day number of Naw-Rúz for the invocant.
# Not that it matters for the arithmetic version of the Baháʼí calendar...
method naw-ruz-number(Int $bahai-year) {
  21;
}


=begin pod

=head1 NAME

=head1 DESCRIPTION

Date::Calendar::Bahai - Conversions from / to the Baháʼí calendar

=head1 SYNOPSIS

Converting a Gregorian date (e.g. 17th May 2021) into Baháʼí

=begin code :lang<raku>

use Date::Calendar::Bahai;
my Date $dt-greg;
my Date::Calendar::Bahai $dt-bahai;

$dt-greg    .= new(2021, 5, 17);
$dt-bahai .= new-from-date($dt-greg);

say $dt-bahai;
# --> 0178-04-01
say $dt-bahai.strftime("%A %d %B %Y");
# --> Kamál 1 ‘Aẓamat 178

=end code

Converting a Bahai date (e.g. 19 Jamál 178) into Gregorian

=begin code :lang<raku>
use Date::Calendar::Bahai;
my  Date::Calendar::Bahai $dt-bahai;
my  Date $dt-greg;

$dt-bahai .= new(year => 178, month => 3, day => 19);
$dt-greg   = $dt-bahai.to-date;

say $dt-greg;
# --> 2021-05-16
=end code

=head1 DESCRIPTION

C<Date::Calendar::Bahai> is a class  representing dates in the initial
Baháʼí calendar,  before the 2015 reform.  It allows you to  convert a
Baháʼí date into Gregorian or into other implemented calendars, and it
allows you  to convert  dates from Gregorian  or from  other calendars
into Baháʼí.

In the Baháʼí  calendar, days begin at sunset. When  converting from /
to  calendar   with  midnight-to-midnight   days,  we  use   the  main
overlapping period, midnight  to sunset. For example,  Kamál 1 ‘Aẓamat
178 begins on 16 May 2021 at sunset and ends on 17 May 2021 at sunset,
the module gives only 17 May.

The years  are numbered  in two different  ways: the  usual sequential
count in  base 10, and  a set of  three embedded 19-year  cycles, each
cycle being numbered 1 to 19. For example, the year beginning in March
2021 and  ending in March  2022 is both year  178 BE (Baháʼí  Era) and
I<year 7  of cycle  10 of  major cycle 1>.  Within the  19-year cycle,
years are  named, so year 178  can also be I<year Abad of cycle  10 of
major cycle 1> or I<year Abad of 10th Váḥid of 1st Kull-i-Shay’a>.

Years are divided in 19 months of 19  days each, plus a period of 4 or
5 additional  days. These additional  days are not  at the end  of the
year, but  I<before> the last  month of  the year. Therefore,  in this
class, months are  numbered 1 to 18 and then  20, while the additional
days are considered as a small  month numbered 19. The reason for this
counterintuitive setup might be that  before 2015, the Baháʼí calendar
was precisely  synchronised with the  Gregorian calendar and  that the
new year  (I<Naw-Rūz>) was  always on  21st of  March. By  putting the
additional days before the last  month, the additional days would span
from 26th February until 1st March, both in normal and leap years, and
the last  month would span  from 2nd March  until 20th March,  both in
normal and leap years.

The distribution provides also the Date::Calendar::Bahai::Astronomical
class which gives the version of the Baháʼí calendar as defined by the
2015 reform.

The calendar  implemented by the  arithmetic module is not  limited to
dates  in the  Gregorian range  1844--2015. It  allows you  to convert
dates after the 2015 reform while pretending the reform did not happen
and that the Baháʼí calendar  is still synchronised with the Gregorian
calendar.

=head1 METHODS

=head2 Constructors

=head3 new

Create an  Baháʼí date by giving  the year, month and  day numbers and
the C<locale> code.

The year can be specified either  by a single parameter C<year>, or by
three parameters C<cycle-year>, C<cycle> and C<major-cycle>.

Currently implemented  locales are C<ar> for  Arabic (default locale),
C<en> for English and C<fr> for French.

=begin code :lang<raku>
use Date::Calendar::Bahai;
my  Date::Calendar::Bahai $dt-bahai;
$dt-bahai .= new(year => 178, month => 3, day => 19);
$dt-bahai .= new(major-cycle => 1, cycle => 10, cycle-year => 7, month => 3, day => 19);
=end code

=head3 new-from-date

Build an  Baháʼí date by  cloning an  object from another  class. This
other   class    can   be    the   core    class   C<Date>    or   any
C<Date::Calendar::>R<xxx> class with a C<daycount> method.

=head3 new-from-daycount

Build an Baháʼí date from the Modified Julian Day number.

=head2 Accessors

=head3 gist

Gives a short string representing the date, in C<YYYY-MM-DD> format.

=head3 year, month, day

The numbers defining the date.

=head3 major-cycle, cycle, cycle-year

The alternate definition of the year.

=head3 month-name

The month of the date, as a string.

=head3 month-abbr

The month of the  date, as a 3-char string.

=head3 day-name

The name of the day within the week.

=head3 day-abbr

The weekday of the  date, as a 3-char string.

=head3 cycle-year-name

The name associated to the year within the 19-year cycle.

=head3 daycount

Convert  the date  to Modified  Julian Day  Number (a  day-only scheme
based on 17 November 1858).

=head3 day-of-week

The number of the  day within the week (1 for Saturday  / Jalál, 7 for
Friday / Istiqlál).

=head3 week-number

The number of the week within the year, 1 to 52 or 1 to 53. Similar to
the "ISO  date" as defined  for Gregorian date.  Week number 1  is the
Sat→Fri span that contains the first Tuesday / Fiḍál of the year, week
number 2 is the Sat→Fri span  that contains the second Tuesday / Fiḍál
of the year and so on.

=head3 week-year

Mostly similar  to the C<year>  attribute. Yet,  the last days  of the
year  and  the  first  days  of the  following  year  can  be  sort-of
transferred  to the  other year.  The C<week-year>  attribute reflects
this transfer. While the real year  always begins on 1st Bahá and ends
on the  19th Alá, the C<week-year>  always begins on Saturday  / Jalál
and it always ends on Friday / Istiqlál.

=head3 day-of-year

How many  days since  the beginning of  the year. 1  to 365  on normal
years, 1 to 366 on leap years.

=head3 is-leap

Returns C<True> if the invocant date  belongs to a leap year, C<False>
if the invocant date belongs to a normal year.

This method  allows an  optional parameter, to  specify a  Baháʼí year
(the single-number  version). If this  parameter is supplied,  and the
parameter  year  is tested  for  leapness  and  the invocant  date  is
ignored.

=begin code :lang<raku>
use Date::Calendar::Bahai;
my  Date::Calendar::Bahai $dt-bahai;

$dt-bahai .= new(year => 178, month => 3, day => 19);

if $dt-bahai.is-leap {
  say $dt-bahai.year, " is a leap year";
}
if $dt-bahai.is-leap(180) {
  say "180 is a leap year";
}

=end code


=head2 Other Methods

=head3 to-date

Clones  the   date  into   a  core  class   C<Date>  object   or  some
C<Date::Calendar::>R<xxx> compatible calendar  class. The target class
name is given  as a positional parameter. This  parameter is optional,
the default value is C<"Date"> for the Gregorian calendar.

To convert a date from a  calendar to another, you have two conversion
styles,  a "push"  conversion and  a "pull"  conversion. For  example,
while  converting  "11  Bahman   1440"  to  the  French  Revolutionary
calendar, you can code:

=begin code :lang<perl6>

use Date::Calendar::Bahai;
use Date::Calendar::FrenchRevolutionary;

my  Date::Calendar::Bahai               $d-orig;
my  Date::Calendar::FrenchRevolutionary $d-dest-push;
my  Date::Calendar::FrenchRevolutionary $d-dest-pull;

$d-orig .= new(year  => 178
             , month =>   4
             , day   =>   4);
$d-dest-push  = $d-orig.to-date("Date::Calendar::FrenchRevolutionary");
$d-dest-pull .= new-from-date($d-orig);

=end code

When converting  I<from> the core  class C<Date>, use the  pull style.
When converting I<to> the core class C<Date>, use the push style. When
converting from  any class other  than the  core class C<Date>  to any
other  class other  than the  core class  C<Date>, use  the style  you
prefer. For the Gregorian calendar, instead of the core class C<Date>,
you can use the  child class C<Date::Calendar::Gregorian> which allows
both push and pull styles.


=head1 BUGS AND ISSUES

Although there  are 19 real months,  the months are numbered  until 20
because the additional days (I<Ayyám-i-Há>)  are considered as a short
pseudo-month  numbered  19,  so  month I<Alá>  is  numbered  20.  This
numbering scheme allows  easy sorting of dates  with the C<YYYY-MM-DD>
format.  On  the  other  hand,  it is  incompatible  with  some  other
programs'  numbering scheme,  notably  F<calendar.l>  by Reingold  and
Dershowitz.

Is the major cycle limited to the  1..19 range or is it open-ended? Do
we need  a super-major cycle for  the time when the  major-cycle reach
19? We'll need to settle on  this around Gregorian year 8700, so there
is still time...

The astronomical version is defined  until year 221, that is Gregorian
year  2065.  Beyond that,  the  C<Date::Calendar::Bahai::Astronomical>
class silently reverts to the arithmetic version.

Some months has the same name as  week days. Be careful and do not mix
them.

=head1 SEE ALSO

=head2 Raku Software

L<Date::Calendar::Strftime>
or L<https://github.com/jforget/raku-Date-Calendar-Strftime>

L<Date::Calendar::Gregorian>
or L<https://github.com/jforget/raku-Date-Calendar-Gregorian>

L<Date::Calendar::Julian>
or L<https://github.com/jforget/raku-Date-Calendar-Julian>

L<Date::Calendar::Hebrew>
or L<https://github.com/jforget/raku-Date-Calendar-Hebrew>

L<Date::Calendar::Hijri>
or L<https://github.com/jforget/raku-Date-Calendar-Hijri>

L<Date::Calendar::Persian>
or L<https://github.com/jforget/raku-Date-Calendar-Persian>

L<Date::Calendar::CopticEthiopic>
or L<https://github.com/jforget/raku-Date-Calendar-CopticEthiopic>

L<Date::Calendar::MayaAztec>
or L<https://github.com/jforget/raku-Date-Calendar-MayaAztec>

L<Date::Calendar::FrenchRevolutionary>
or L<https://github.com/jforget/raku-Date-Calendar-FrenchRevolutionary>

=head2 Perl 5 Software

L<Date::Converter>

L<Date::Bahai::Simple>

=head2 Other Software

date(1), strftime(3)

F<calendar/cal-bahai.el>  in emacs  or xemacs.

CALENDRICA 4.0 -- Common Lisp, which can be downloaded in the "Resources" section of
L<https://www.cambridge.org/us/academic/subjects/computer-science/computing-general-interest/calendrical-calculations-ultimate-edition-4th-edition?format=PB&isbn=9781107683167>

=head2 Book

Calendrical Calculations (Third or Fourth Edition) by Nachum Dershowitz and
Edward M. Reingold, Cambridge University Press, see
L<http://www.calendarists.com>
or L<https://www.cambridge.org/us/academic/subjects/computer-science/computing-general-interest/calendrical-calculations-ultimate-edition-4th-edition?format=PB&isbn=9781107683167>.

=head2 Internet

L<https://bahai-library.com/uhj_badi_calendar_2014>

L<https://www.badi-calendar.com/faq.php>

L<https://www.funaba.org/cc>

L<https://en.wikipedia.org/wiki/Bah%C3%A1%27%C3%AD_calendar>

L<https://icalendrier.fr/calendriers-saga/calendriers/baha-i> (in French)

=head1 AUTHOR

Jean Forget <JFORGET@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2021 Jean Forget, all rights reserved.

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
