# -*- encoding: utf-8; indent-tabs-mode: nil -*-

use Date::Calendar::Strftime;
use Date::Calendar::Bahai::Names;
use Date::Calendar::Bahai::Common;

unit class Date::Calendar::Bahai:ver<0.1.1>:auth<zef:jforget>:api<1>
      does Date::Calendar::Bahai::Common
      does Date::Calendar::Strftime;

multi method BUILD(Int:D :$year, Int:D :$month, Int:D :$day, Str :$locale = 'ar', Int :$daypart = daylight()) {
  self!check-build-args1($year, $month, $day, $locale);
  self!build-from-args1( $year, $month, $day, $locale, $daypart);
}

multi method BUILD(Int:D :$major-cycle, Int:D :$cycle, Int:D :$cycle-year
                 , Int:D :$month,       Int:D :$day,   Str   :$locale = 'ar'
                 , Int   :$daypart = daylight()) {
  self!check-build-args2($major-cycle, $cycle, $cycle-year, $month, $day, $locale);
  self!build-from-args2( $major-cycle, $cycle, $cycle-year, $month, $day, $locale, $daypart);
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
say $dt-bahai.strftime("%A %e %B %Y");
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

Converting a date while caring about sunset:

=begin code :lang<raku>

use Date::Calendar::Strftime;
use Date::Calendar::Bahai;

my Date::Calendar::Bahai $dt-bahai;
my Date                  $dt-greg;

$dt-bahai .= new(year => 181, month => 13, day => 11, daypart => after-sunset());
$dt-greg   = $dt-bahai.to-date;
say $dt-greg.gist;   # --> 2024-11-13

# on the other hand
$dt-bahai .= new(year => 181, month => 13, day => 11, daypart => before-sunrise());
$dt-greg   = $dt-bahai.to-date;
say $dt-greg.gist;   # --> 2024-11-14

$dt-bahai .= new(year => 181, month => 13, day => 11, daypart => daylight());
$dt-greg   = $dt-bahai.to-date;
say $dt-greg.gist;   # --> 2024-11-14

=end code

=head1 DESCRIPTION

C<Date::Calendar::Bahai> is a class  representing dates in the initial
Baháʼí calendar,  before the 2015 reform.  It allows you to  convert a
Baháʼí date into Gregorian or into other implemented calendars, and it
allows you  to convert  dates from Gregorian  or from  other calendars
into Baháʼí.

In the Baháʼí  calendar, days begin at sunset. When  converting from /
to calendar with midnight-to-midnight days,  be sure to add the proper
C<daypart> build parameter to get the proper converted date.

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
the C<locale>  code, plus optionally the  day part (C<before-sunrise>,
C<daylight> or C<after-sunset>).

The year can be specified either  by a single parameter C<year>, or by
three parameters C<cycle-year>, C<cycle> and C<major-cycle>.

Currently implemented  locales are C<ar> for  Arabic (default locale),
C<en> for English and C<fr> for French.

=begin code :lang<raku>
use Date::Calendar::Strftime;
use Date::Calendar::Bahai;
my  Date::Calendar::Bahai $dt-bahai;
$dt-bahai .= new(year => 178, month => 3, day => 19);
$dt-bahai .= new(major-cycle => 1, cycle => 10, cycle-year => 7, month => 3, day => 19);
$dt-bahai .= new(year => 178, month => 3, day => 19, daypart => after-sunset(), locale => 'fr');
=end code

=head3 new-from-date

Build an  Baháʼí date by  cloning an  object from another  class. This
other   class    can   be    the   core    class   C<Date>    or   any
C<Date::Calendar::>R<xxx>  class   with  a  C<daycount>   method  and,
hopefully, a C<daypart> method.

=head3 new-from-daycount

Build  an Baháʼí  date from  the Modified  Julian Day  number and  the
C<daypart> value.

=head2 Accessors

=head3 gist

Gives a short string representing the date, in C<YYYY-MM-DD> format.

=head3 year, month, day

The numbers defining the date.

=head3 major-cycle, cycle, cycle-year

The alternate definition of the year.

For C<strftime>, see the specifiers C<%K>, C<%k> and C<%y>.

=head3 daypart

A  number indicating  which part  of the  day. This  number should  be
filled   and   compared   with   the   following   subroutines,   with
self-documenting names:

=item before-sunrise()
=item daylight()
=item after-sunset()

For C<strftime>, see the specifier C<%Ep>.

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

The Modified Julian Day Number (a day-only scheme based on 17 November
1858).

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
while converting "Istijlál 4 ‘Aẓamat  178" to the French Revolutionary
calendar, you can code:

=begin code :lang<raku>

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
say $d-orig, ' ', $d-dest-push, ' ', $d-dest-pull;
# --> "178-04-04 0229-09-01 0229-09-01"

=end code

When converting  I<from> the core  class C<Date>, use the  pull style.
When converting I<to> the core class C<Date>, use the push style. When
converting from  any class other  than the  core class C<Date>  to any
other  class other  than the  core class  C<Date>, use  the style  you
prefer. For the Gregorian calendar, instead of the core class C<Date>,
you can use the  child class C<Date::Calendar::Gregorian> which allows
both push and pull styles.

=head3 strftime

This method is  very similar to the homonymous functions  you can find
in several  languages (C, shell, etc).  It also takes some  ideas from
C<printf>-similar functions. For example

=begin code :lang<raku>

$dt.strftime("%04d blah blah blah %-25B")

=end code

will give  the day number  padded on  the left with  2 or 3  zeroes to
produce a 4-digit substring, plus the substring C<" blah blah blah ">,
plus the month name, padded on the right with enough spaces to produce
a 25-char substring. Thus, the whole  string will be at least 42 chars
long. By  the way, you  can drop the  "at least" mention,  because the
longest month name  is 10-char long, so the padding  will always occur
and will always include at least 15 spaces.

A C<strftime> specifier consists of:

=item A percent sign,

=item An  optional minus sign, to  indicate on which side  the padding
occurs. If the minus sign is present, the value is aligned to the left
and the padding spaces are added to the right. If it is not there, the
value is aligned to the right and the padding chars (spaces or zeroes)
are added to the left.

=item  An  optional  zero  digit,  to  choose  the  padding  char  for
right-aligned values.  If the  zero char is  present, padding  is done
with zeroes. Else, it is done wih spaces.

=item An  optional length, which  specifies the minimum length  of the
result substring.

=item  An optional  C<"E">  or  C<"O"> modifier.  On  some older  UNIX
system,  these  were used  to  give  the I<extended>  or  I<localized>
version  of  the date  attribute.  Here,  they rather  give  alternate
variants of the date attribute.

=item A mandatory type code.

The allowed type codes are:

=defn %a

The abbreviated day of week.

=defn %A

The full day of week name.

=defn %b

The abbreviated month name.

=defn %B

The full month name.

=defn %d

The day of the month as a decimal number (range 01 to 19).

=defn %e

Like C<%d>, the  day of the month  as a decimal number,  but a leading
zero is replaced by a space.

=defn %f

The month as a decimal number (1  to 20). Unlike C<%m>, a leading zero
is replaced by a space.

=defn %F

Equivalent to %Y-%m-%d (the ISO 8601 date format)

=defn %G

The "week year"  as a decimal number. Mostly similar  to C<%Y>, but it
may differ  on the very  first days  of the year  or on the  very last
days. Analogous to the year number  in the so-called "ISO date" format
for Gregorian dates.

=defn %j

The day of the year as a decimal number (range 001 to 366).

=defn %k

The cycle as a decimal number (range 1 to 19).

=defn %K

The major cycle as a decimal number.

=defn %m

The month as a two-digit decimal  number (range 01 to 20), including a
leading zero if necessary.

=defn %n

A newline character.

=defn %Ep

Gives a 1-char string representing the day part:

=item C<☾> or C<U+263E> before sunrise,
=item C<☼> or C<U+263C> during daylight,
=item C<☽> or C<U+263D> after sunset.

Rationale: in  C or in  other programming languages,  when C<strftime>
deals with a date-time object, the day is split into two parts, before
noon and  after noon. The  C<%p> specifier  reflects this by  giving a
C<"AM"> or C<"PM"> string.

The  3-part   splitting  in   the  C<Date::Calendar::>R<xxx>   may  be
considered as  an alternate  splitting of  a day.  To reflect  this in
C<strftime>, we use an alternate version of C<%p>, therefore C<%Ep>.

=defn %t

A tab character.

=defn %u

The day of week as a 1..7 number.

=defn %V

The week  number as defined above,  similar to the week  number in the
so-called "ISO date" format for Gregorian dates.

=defn %Y

The year as a decimal number.

=defn %y

The cycle-year as a decimal number.

On other systems and other languages,  the C<%y> specifier is used for
the stupid and  dangerous action of truncating the  year number, which
paved the way  for the Y2K bug. With the  principle of least surprise,
this specifier is used here to  give the I<short variant of the year>,
that is, the  1-to-19 cycle-year. Unlike the other  calendars, the use
of a I<short variant> here is a legitimate one.

See also C<%k> and C<%K>.

=defn %Ey

The name of the cycle-year.

=defn %%

A literal `%' character.

=head1 BUGS AND ISSUES

Although there  are 19 real months,  the months are numbered  until 20
because the additional days (I<Ayyám-i-Há>)  are considered as a short
pseudo-month  numbered  19,  so  month I<Alá>  is  numbered  20.  This
numbering scheme allows  easy sorting of dates  with the C<YYYY-MM-DD>
format.  On  the  other  hand,  it is  incompatible  with  some  other
programs'  numbering scheme,  notably  C<calendar.l>  by Reingold  and
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

=head2 Security issues

Another  issue,   as  explained  in   the  C<Date::Calendar::Strftime>
documentation. Please ensure that  format-string passed to C<strftime>
comes from  a trusted source.  Failing that, the untrusted  source can
include a outrageous  length in a C<strftime> specifier  and this will
drain your PC's RAM very fast.

=head2 Relations with :ver<0.0.x> classes and with core class Date

Version 0.1.0 (and API 1) was  introduced to ease the conversions with
other calendars in  which the day is  defined as midnight-to-midnight.
If all C<Date::Calendar::>R<xxx> classes use  version 0.1.x and API 1,
the conversions will be correct. But if some C<Date::Calendar::>R<xxx>
classes use version 0.0.x and API 0, there might be problems.

A date from a 0.0.x class has no C<daypart> attribute. But when "seen"
from  a  0.1.x class,  the  0.0.x  date  seems  to have  a  C<daypart>
attribute equal to C<daylight>. When converted from a 0.1.x class to a
0.0.x  class,  the  date  may  just  shift  from  C<after-sunset>  (or
C<before-sunrise>) to C<daylight>, or it  may shift to the C<daylight>
part of  the prior (or  next) date. This  means that a  roundtrip with
cascade conversions  may give the  starting date,  or it may  give the
date prior or after the starting date.

If you install C<<Date::Calendar::Bahai:ver<0.1.1>>>, why would you
refrain from upgrading other C<Date::Calendar::>R<xxxx> classes? So
actually, this issue applies mainly to the core class C<Date>, because
you may prefer avoiding the installation of
C<Date::Calendar::Gregorian>.

=head2 Time

This module  and the C<Date::Calendar::>R<xxx> associated  modules are
still date  modules, they are not  date-time modules. The user  has to
give  the C<daypart>  attribute  as a  value among  C<before-sunrise>,
C<daylight> or C<after-sunset>. There is no provision to give a HHMMSS
time and convert it to a C<daypart> parameter.

=head1 SEE ALSO

=head2 Raku Software

L<Date::Calendar::Strftime|https://raku.land/zef:jforget/Date::Calendar::Strftime>
or L<https://github.com/jforget/raku-Date-Calendar-Strftime>

L<Date::Calendar::Gregorian|https://raku.land/zef:jforget/Date::Calendar::Gregorian>
or L<https://github.com/jforget/raku-Date-Calendar-Gregorian>

L<Date::Calendar::Julian|https://raku.land/zef:jforget/Date::Calendar::Julian>
or L<https://github.com/jforget/raku-Date-Calendar-Julian>

L<Date::Calendar::Hebrew|https://raku.land/zef:jforget/Date::Calendar::Hebrew>
or L<https://github.com/jforget/raku-Date-Calendar-Hebrew>

L<Date::Calendar::Hijri|https://raku.land/zef:jforget/Date::Calendar::Hijri>
or L<https://github.com/jforget/raku-Date-Calendar-Hijri>

L<Date::Calendar::Persian|https://raku.land/zef:jforget/Date::Calendar::Persian>
or L<https://github.com/jforget/raku-Date-Calendar-Persian>

L<Date::Calendar::CopticEthiopic|https://raku.land/zef:jforget/Date::Calendar::CopticEthiopic>
or L<https://github.com/jforget/raku-Date-Calendar-CopticEthiopic>

L<Date::Calendar::MayaAztec|https://raku.land/zef:jforget/Date::Calendar::MayaAztec>
or L<https://github.com/jforget/raku-Date-Calendar-MayaAztec>

L<Date::Calendar::FrenchRevolutionary|https://raku.land/zef:jforget/Date::Calendar::FrenchRevolutionary>
or L<https://github.com/jforget/raku-Date-Calendar-FrenchRevolutionary>

=head2 Perl 5 Software

L<Date::Converter|https://metacpan.org/pod/Date::Converter>

L<Date::Bahai::Simple|https://metacpan.org/pod/Date::Bahai::Simple>

=head2 Other Software

date(1), strftime(3)

C<calendar/cal-bahai.el>  in emacs  or xemacs.

L<https://pypi.org/project/convertdate/>
or L<https://convertdate.readthedocs.io/en/latest/modules/bahai.html>

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
(website no longer works).

L<https://www.ephemeride.com/calendrier/autrescalendriers/21/autres-types-de-calendriers.html>
(in French)

L<https://en.wikipedia.org/wiki/Bah%C3%A1%27%C3%AD_calendar>

L<https://icalendrier.fr/calendriers-saga/calendriers/baha-i> (in French)

=head1 AUTHOR

Jean Forget <J2N-FORGET at orange dot fr>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2021, 2024, 2025 Jean Forget, all rights reserved.

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
