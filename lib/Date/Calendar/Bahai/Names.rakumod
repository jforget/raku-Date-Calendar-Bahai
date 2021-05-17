use v6.c;
unit module Date::Calendar::Bahai::Names:ver<0.0.1>:auth<cpan:JFORGET>;

my @month-names = (
);

my @month-abbr = < 
                   >
;

my @day-names = ( 
);

my @day-abbr =  ( 
);

our sub month-name(Int:D $month --> Str) {
  return @month-names[$month - 1];
}

our sub month-abbr(Int:D $month --> Str) {
  return @month-abbr[$month - 1];
}

our sub day-name(Int:D $day7 --> Str) {
  return @day-names[$day7];
}

our sub day-abbr(Int:D $day7 --> Str) {
  return @day-abbr[$day7];
}


=begin pod

=head1 NAME

Date::Calendar::Bahai::Names - string values for the Baháʼí calendar

=head1 SYNOPSIS

=begin code :lang<perl6>

use Date::Calendar::Bahai;

=end code

=head1 DESCRIPTION

Date::Calendar::Bahai::Names  is a  utility  module, providing  string
values for the main module Date::Calendar::Bahai.

=head1 SOURCES

The names come from
L<https://icalendrier.fr/calendriers-saga/calendriers/baha-i>

The English names come from
L<https://en.wikipedia.org/wiki/Bah%C3%A1%27%C3%AD_calendar>

=head1 SEE ALSO

=head2 Perl 5 Software

L<Date::Bahai::Simple>

=head2 Other Software

date(1), strftime(3)

F<calendar/cal-bahai.el>  in emacs  or xemacs.

CALENDRICA 4.0 -- Common Lisp, which can be download in the "Resources" section of
L<https://www.cambridge.org/us/academic/subjects/computer-science/computing-general-interest/calendrical-calculations-ultimate-edition-4th-edition?format=PB&isbn=9781107683167>

=head2 Books

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

Jean Forget <JFORGET at cpan dot org>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2021 Jean Forget, all rights reserved

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
