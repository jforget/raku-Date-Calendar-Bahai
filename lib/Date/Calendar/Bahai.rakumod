# -*- encoding: utf-8; indent-tabs-mode: nil -*-

use Date::Calendar::Strftime;
use Date::Calendar::Bahai::Names;
use Date::Calendar::Bahai::Common;

unit class Date::Calendar::Bahai:ver<0.0.1>:auth<cpan:JFORGET>
      does Date::Calendar::Bahai::Common
      does Date::Calendar::Strftime;


=begin pod

=head1 NAME

=head1 DESCRIPTION

Date::Calendar::Bahai::Astronomical - Conversions from / to the Baháʼí calendar

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

Date::Calendar::Bahai  is a  class representing  dates in  the initial
Baháʼí calendar,  before the 2015 reform.  It allows you to  convert a
Baháʼí date into Gregorian or into other implemented calendars, and it
allows you  to convert  dates from Gregorian  or from  other calendars
into Baháʼí.

The distribution provides also the Date::Calendar::Bahai::Astronomical
class which gives the version of the Baháʼí calendar as defined by the
2015 reform.

The calendar implemented by this module is not limited to dates in the
Gregorian range 1844--2015.  It allows you to convert  dates after the
2015 reform while pretending the reform did not happen.


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

Jean Forget <JFORGET@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2021 Jean Forget, all rights reserved.

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
