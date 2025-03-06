# -*- encoding: utf-8; indent-tabs-mode: nil -*-

use Date::Calendar::Bahai::Names;
use Date::Calendar::Strftime;

unit role Date::Calendar::Bahai::Common:ver<0.1.1>:auth<zef:jforget>:api<1>;

has Int $.year;
has Int $.month      where { 1 ≤ $_ ≤ 20 };
has Int $.day        where { 1 ≤ $_ ≤ 19 };
has Int $.daycount;
has Int $.daypart where { before-sunrise() ≤ $_ ≤ after-sunset() };
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
    # Checking the additional days (Ayyám-i-Há), within either the 1..4 range or the 1..5 range.
    if $.is-leap($year) {
      unless 1 ≤ $day ≤ 5 {
        X::OutOfRange.new(:what<Day>, :got($day), :range<1..5>).throw;
      }
    }
    else {
      unless 1 ≤ $day ≤ 4 {
        X::OutOfRange.new(:what<Day>, :got($day), :range<1..4>).throw;
      }
    }
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
  self!check-build-args1(year-number($major-cycle, $cycle, $cycle-year), $month, $day, $locale);
}

method !build-from-args2(Int $major-cycle, Int $cycle, Int $cycle-year, Int $month, Int $day, Str $locale, Int $daypart) {
  self!build-from-args1(year-number($major-cycle, $cycle, $cycle-year), $month, $day, $locale, $daypart);
}

method !build-from-args1(Int $year, Int $month, Int $day, Str $locale, Int $daypart) {
  $!year    = $year;
  $!month   = $month;
  $!day     = $day;
  $!daypart = $daypart;
  $!locale  = $locale;

  ($!cycle-year, $!cycle, $!major-cycle) = ($year - 1).polymod(19, 19) «+» 1;
  my Int $doy = $day + 19 × ($month - 1);
  if $month == 20 and $.is-leap($year) {
    $doy -= 14; # only 5 additional days, not 19, in pseudo-month Ayyám-i-Há
  }
  elsif $month == 20 {
    $doy -= 15; # only 4 additional days, not 19, in pseudo-month Ayyám-i-Há
  }
  my Int $daycount = $doy - 1 + Date.new($year + 1843, 3, $.naw-ruz-number($year)).daycount;
  my Int $dow      = ($daycount + 4) % 7 + 1;
  $!day-of-week = $dow;
  $!day-of-year = $doy;
  if $daypart == after-sunset() {
    # after computing $doy and not before!
    --$daycount;
  }
  $!daycount    = $daycount;

  # computing week-related derived attributes
  my Int $doy-fidal = $doy - $dow + 4; # day-of-year value for the nearest Fiḍál / Tuesday
  my Int $week-year = $year;
  if $doy-fidal ≤ 0 {
    -- $week-year;
    if self.is-leap($week-year) {
      $doy += 366;
    }
    else {
      $doy += 365;
    }
    $doy-fidal = $doy - $dow + 4;
  }
  else {
    my Int $year-length;
    if self.is-leap($week-year) {
      $year-length = 366;
    }
    else {
      $year-length = 365;
    }
    if $doy-fidal > $year-length {
      $doy      -= $year-length;
      $doy-fidal = $doy - $dow + 4;
      ++ $week-year;
    }
  }
  my Int $week-number = ($doy-fidal / 7).ceiling;

  # storing week-related derived attributes
  $!week-number = $week-number;
  $!week-year   = $week-year;
}

method gist {
  sprintf("%04d-%02d-%02d", $.year, $.month, $.day);
}

method month-name {
  Date::Calendar::Bahai::Names::month-name($.locale, $.month);
}

method month-abbr {
  Date::Calendar::Bahai::Names::month-abbr($.locale, $.month);
}

method day-name {
  Date::Calendar::Bahai::Names::day-name($.locale, $.day-of-week);
}

method day-abbr {
  Date::Calendar::Bahai::Names::day-abbr($.locale, $.day-of-week);
}

method cycle-year-name {
  Date::Calendar::Bahai::Names::cycle-year-name($.locale, $.cycle-year);
}

method new-from-date($date) {
  $.new-from-daycount($date.daycount, daypart => $date.?daypart // daylight);
}

method new-from-daycount(Int $daycount is copy, Int :$daypart = daylight) {
  if $daypart == after-sunset() {
    ++$daycount;
  }
  my Date $bahai-epoch .= new(1844, 3, 21);
  my Int  $shifted-doy;  # shifted by 1, e.g. Naw-Rúz (or 1st Bahá) is 0 and not 1
  my Str  $class = $.^name;

  # First estimated value is deliberately off by 1, because of pre-decrement
  # but in some cases, it may be off by 2.
  # After 365 leap days have been accumulated, that is after 1460 years, the estimated
  # value may even be off by 3.
  my Int $year = 1 + (($daycount - $bahai-epoch.daycount + 1) / 365).ceiling;
  loop {
    -- $year ;
    my $naw-ruz = ::($class).new(year => $year, month => 1, day => 1);
    $shifted-doy = $daycount - $naw-ruz.daycount;
    last if $shifted-doy ≥ 0;
  }
  my $shifted-last-ayyam-doy = 345; # 4th Ayyám-i-Há is the 346th day of the year
  if $.is-leap($year) {
    $shifted-last-ayyam-doy = 346; # 5th Ayyám-i-Há is the 347th day of a leap year
  }
  if $shifted-doy > $shifted-last-ayyam-doy {
    return $.new(year => $year, month => 20, day => $shifted-doy - $shifted-last-ayyam-doy, daypart => $daypart);
  }
  else {
    my ($day, $month) = $shifted-doy.polymod(19) «+» 1;
    return $.new(year => $year, month => $month, day => $day, daypart => $daypart);
  }
}

method to-date($class = 'Date') {
  # See "Learning Perl 6" page 177
  my $d = ::($class).new-from-daycount($.daycount, daypart => $.daypart);
  return $d;
}

method is-leap($year = $.year --> Bool) {
  my Int  $naw-ruz-before = $.naw-ruz-number($year);
  my Int  $naw-ruz-after  = $.naw-ruz-number($year + 1);
  my Bool $is-leap     = False;

  # How does it work? We compute the March number of two successive Naw-Rúz
  # dates. Then we compare the values and we check if the comparison is compatible with a
  # leap Baháʼí year and with a leap Gregorian year.
  #
  # Examples
  #
  # Baháʼí year                  172            173            174
  # Gregorian year before       2015           2016           2017
  # Gregorian year after        2016           2017           2018
  # $naw-ruz-before               21             20             20
  # $naw-ruz-after                20             20             21
  #
  # Check                   $nr-b > $nr-a  $nr-b == $nr-a  $nr-b < $nr-a
  #
  # Duration between $nr-b and $nr-a
  # if normal Greg year    365-1=364          +-365      365+1=366-+
  # if leap   Greg year    366-1=365-+        | 366-+    366+1=367 |
  #                                  |        |     |              |
  # if normal Baháʼí year        365-+        +-365 |          365 |
  # if leap   Baháʼí year        366            366-+          366-+
  #                                |              |              |
  # Conclusion                     |              |              `-- the Gregorian year is normal
  #                                |              |                  and the Baháʼí year is leap
  #                                |              `----------------- the Gregorian and Baháʼí years
  #                                |                                 are both normal or they are both leap
  #                                `-------------------------------- the Gregorian year is leap
  #                                                                  and the Baháʼí year is normal
  #
  # Remark: the Gregorian year checked for leapness / normality is the Gregorian year "after",
  # because the Baháʼí year includes the February month from the Greg year "after" but
  # not from the Greg year "before".

  if $naw-ruz-before < $naw-ruz-after {
    $is-leap = True;
  }
  elsif $naw-ruz-before == $naw-ruz-after {
    $is-leap = Date.new($year + 1844, 1, 1).is-leap-year;
  }
  return $is-leap
}

sub year-number(Int $major-cycle, Int $cycle, Int $cycle-year --> Int) {
  return (($major-cycle - 1) × 19 + ($cycle - 1)) × 19 + $cycle-year;
}

method specific-format { %(  y => { $.cycle-year },
                            Ey => { Date::Calendar::Bahai::Names::cycle-year-name($.locale, $.cycle-year); },
                             k => { $.cycle },
                             K => { $.major-cycle }
                            ) }

=begin pod

=head1 NAME

Date::Calendar::Bahai::Common - Behind-the-scene role for Date::Calendar::Bahai and Date::Calendar::Bahai::Astronomical

=head1 DESCRIPTION

This role  is not meant  to be used directly  by user programs.  It is
meant    to   be    used   by    the   C<Date::Calendar::Bahai>    and
C<Date::Calendar::Bahai::Astronomical> classes. Please refer to theses
classes' documentation.

=head1 AUTHOR

Jean Forget <J2N-FORGET at orange dot fr>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2021, 2024, 2025 Jean Forget

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
