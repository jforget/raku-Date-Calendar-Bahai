# -*- encoding: utf-8; indent-tabs-mode: nil -*-

use Date::Calendar::Bahai::Names;
use Date::Calendar::Strftime;

unit role Date::Calendar::Bahai::Common:ver<0.0.1>:auth<cpan:JFORGET>;

has Int $.year;
has Int $.month      where { 1 ≤ $_ ≤ 20 };
has Int $.day        where { 1 ≤ $_ ≤ 19 };
has Int $.daycount;
has Int $.day-of-year;
has Int $.day-of-week;
has Int $.week-number;
has Int $.week-year;
has Int $.cycle-year where { 1 ≤ $_ ≤ 19 };
has Int $.cycle      where { 1 ≤ $_ ≤ 19 };
has Int $.major-cycle;
has Str $.locale is rw;

method !check-build-args1(Int $year, Int $month, Int $day, Str $locale) {
  if $year ≤ 0 {
    X::OutOfRange.new(:what<Year>, :got($year), :range<1..inf>).throw;
  }
  unless 1 ≤ $month ≤ 20 {
    X::OutOfRange.new(:what<Month>, :got($month), :range<1..20>).throw;
  }
  if $month ≠ 19 {
    unless 1 ≤ $day ≤ 19 {
      X::OutOfRange.new(:what<Day>, :got($day), :range<1..19>).throw;
    }
  }
  else {
    # TODO : checking the day number during the additional days pseudo-month
    #my Int $limit =  month-days($year, $month, &bias);
    #unless 1 ≤ $day ≤ $limit {
    #  X::OutOfRange.new(:what<Day>, :got($day), :range("1..$limit for additional days this year")).throw;
    #}
  }
  unless Date::Calendar::Bahai::Names::allowed-locale($locale) {
    X::Invalid::Value.new(:method<BUILD>, :name<locale>, :value($locale)).throw;
  }
}

method !check-build-args2(Int $major-cycle, Int $cycle, Int $cycle-year, Int $month, Int $day, Str $locale) {
  unless 1 ≤ $cycle ≤ 19 {
    X::OutOfRange.new(:what<Cycle>, :got($cycle), :range<1..19>).throw;
  }
  unless 1 ≤ $cycle-year ≤ 19 {
    X::OutOfRange.new(:what<Cycle-year>, :got($cycle-year), :range<1..19>).throw;
  }
  $_!check-build-args1(year-number($major-cycle, $cycle, $cycle-year), $month, $day, $locale);
}

method !build-from-args2(Int $major-cycle, Int $cycle, Int $cycle-year, Int $month, Int $day, Str $locale) {
  self!build-from-args1(year-number($major-cycle, $cycle, $cycle-year), $month, $day, $locale);
}

method !build-from-args1(Int $year, Int $month, Int $day, Str $locale) {
  $!year   = $year;
  $!month  = $month;
  $!day    = $day;
  $!locale = $locale;
  # TODO : fill the other attributes
}

sub year-number(Int $major-cycle, Int $cycle, Int $cycle-year --> Int) {
  return (($major-cycle - 1) × 19 + ($cycle - 1)) × 19 + $cycle-year;
}

=begin pod

=head1 NAME

Date::Calendar::Bahai::Common - Behind-the-scene role for Date::Calendar::Bahai and Date::Calendar::Bahai::Astronomical

=head1 DESCRIPTION

This role  is not meant  to be used directly  by user programs.  It is
meant    to   be    used   by    the   C<Date::Calendar::Bahai>    and
C<Date::Calendar::Bahai::Astronomical> classes. Please refer to theses
classes' documentation.

=head1 AUTHOR

Jean Forget <JFORGET@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2021 Jean Forget

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
