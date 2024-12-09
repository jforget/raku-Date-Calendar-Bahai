# -*- encoding: utf-8; indent-tabs-mode: nil -*-

use Date::Calendar::Strftime;
use Date::Calendar::Bahai::Names;
use Date::Calendar::Bahai::Common;

unit class Date::Calendar::Bahai::Astronomical:ver<0.1.0>:auth<zef:jforget>:api<1>
      does Date::Calendar::Bahai::Common
      does Date::Calendar::Strftime;

multi method BUILD(Int:D :$year, Int:D :$month, Int:D :$day, Str :$locale = 'ar', Int :$daypart = daylight()) {
  self!check-build-args1($year, $month, $day, $locale);
  self!build-from-args1( $year, $month, $day, $locale, $daypart);
}

multi method BUILD(Int:D :$major-cycle, Int:D :$cycle, Int:D :$cycle-year
                 , Int:D :$month,       Int:D :$day,   Str   :$locale = 'ar'
                 , Int :$daypart = daylight()) {
  self!check-build-args2($major-cycle, $cycle, $cycle-year, $month, $day, $locale);
  self!build-from-args2( $major-cycle, $cycle, $cycle-year, $month, $day, $locale, $daypart);
}

# If $bahai-year is given, gives the March day number of Naw-Rúz for the given year.
# If $bahai-year is omitted, gives the March day number of Naw-Rúz for the invocant.
# Data based on the https://bahai-library.com/pdf/uhj/uhj_badi_calendar_2014.pdf document
# (see https://bahai-library.com/uhj_badi_calendar_2014)
method naw-ruz-number(Int $bahai-year = $.year) {
  if $bahai-year < 172 || $bahai-year > 221 {
    return 21;
  }
  if $bahai-year == 172 | 175 | 176 | 179 | 180 | 183 | 184 | 188 | 192 | 196 | 200 | 204 | 208 | 212 {
    return 21;
  }
  return 20;
}

=begin pod

=head1 NAME

Date::Calendar::Bahai::Astronomical - Conversions from / to the astronomical Baháʼí calendar

=head1 SYNOPSIS

Converting a Gregorian date (e.g. 17th May 2021) into Baháʼí

=begin code :lang<raku>

use Date::Calendar::Bahai::Astronomical;
my Date $dt-greg;
my Date::Calendar::Bahai::Astronomical $dt-bahai;

$dt-greg  .= new(2021, 5, 17);
$dt-bahai .= new-from-date($dt-greg);

say $dt-bahai;
# --> 0178-04-02
say $dt-bahai.strftime("%A %d %B %Y");
# --> Kamál 02 ‘Aẓamat 0178

=end code

Converting a Bahai date (e.g. Jalál 1 Bahá 178) into Gregorian

=begin code :lang<raku>
use Date::Calendar::Bahai::Astronomical;
my  Date::Calendar::Bahai::Astronomical $dt-bahai;
my  Date $dt-greg;

$dt-bahai .= new(year => 178, month => 1, day => 1);
$dt-greg   = $dt-bahai.to-date;

say $dt-greg;
# --> 2021-03-20
=end code

=head1 DESCRIPTION

Date::Calendar::Bahai::Astronomical is  a class representing  dates in
the astronomical  Baháʼí calendar, as  defined by the 2015  reform. It
allows  you to  convert a  Baháʼí date  into Gregorian  or into  other
implemented  calendars,  and  it  allows you  to  convert  dates  from
Gregorian or from other calendars into Baháʼí.

The distribution  provides also the Date::Calendar::Bahai  class which
gives the  arithmetic version  of the  Baháʼí calendar.  For Gregorian
dates  in the  1844--2014 interval,  that  is before  the reform,  the
arithmetic and astronomical versions give the same results.

The astronomical Baháʼí calendar is only partially implemented. It can
represent  dates only  in the  1 to  221 years  (1844 to  2064 in  the
Gregorian calendar).

Please see L<Date::Calendar::Bahai> for the complete documentation.

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

L<Date::Bahai::Simple|https://metacpan.org/pod/Date::Bahai::Simple>

=head2 Other Software

date(1), strftime(3)

C<calendar/cal-bahai.el>  in emacs  or xemacs.

CALENDRICA 4.0 -- Common Lisp, which can be download in the "Resources" section of
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

Jean Forget <J2N-FORGET at orange dot fr>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2021, 2024 Jean Forget, all rights reserved.

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
