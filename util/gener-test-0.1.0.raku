#!/usr/bin/env raku
# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
# Générer les données de test pour 08-conv-old.rakutest et 09-conv-new.rakutest
#

use v6.d;
use Date::Calendar::Strftime:api<1>;
use Date::Calendar::Aztec;
use Date::Calendar::Aztec::Cortes;
use Date::Calendar::Bahai;
use Date::Calendar::Bahai::Astronomical;
use Date::Calendar::Coptic;
use Date::Calendar::Ethiopic;
use Date::Calendar::Hebrew;
use Date::Calendar::Hijri;
use Date::Calendar::Gregorian;
use Date::Calendar::FrenchRevolutionary;
use Date::Calendar::FrenchRevolutionary::Arithmetic;
use Date::Calendar::FrenchRevolutionary::Astronomical;
use Date::Calendar::Julian;
use Date::Calendar::Julian::AUC;
use Date::Calendar::Maya;
use Date::Calendar::Maya::Astronomical;
use Date::Calendar::Maya::Spinden;
use Date::Calendar::Persian;
use Date::Calendar::Persian::Astronomical;

my %class =   a0 => 'Date::Calendar::Aztec'
            , a1 => 'Date::Calendar::Aztec::Cortes'
            , ba => 'Date::Calendar::Bahai'
            , be => 'Date::Calendar::Bahai::Astronomical'
            , co => 'Date::Calendar::Coptic'
            , et => 'Date::Calendar::Ethiopic'
            , fr => 'Date::Calendar::FrenchRevolutionary'
            , fa => 'Date::Calendar::FrenchRevolutionary::Arithmetic'
            , fe => 'Date::Calendar::FrenchRevolutionary::Astronomical'
            , gr => 'Date::Calendar::Gregorian'
            , he => 'Date::Calendar::Hebrew'
            , hi => 'Date::Calendar::Hijri'
            , jl => 'Date::Calendar::Julian'
            , jc => 'Date::Calendar::Julian::AUC'
            , m0 => 'Date::Calendar::Maya'
            , m1 => 'Date::Calendar::Maya::Astronomical'
            , m2 => 'Date::Calendar::Maya::Spinden'
            , pe => 'Date::Calendar::Persian'
            , pa => 'Date::Calendar::Persian::Astronomical'
            ;
my %midnight = ba => False
             , be => False
             , co => False
             , et => False
             , fr => True
             , fa => True
             , fe => True
             , gr => True
             , he => False
             , hi => False
             , jl => True
             , jc => True
             , pe => True
             , pa => True
             ;

my @new-maya;
my @new-others;

say '08-conv-old.rakutest variables @data and then @data-greg';
gener-others('ba', 181,  8, 13);
gener-others('be', 181, 18, 11);
gener-others('co', 181, 15, 12);
gener-others('et', 181, 11, 16);
gener-others('fr', 179,  3,  8);
gener-others('fa', 181, 17,  7);
gener-others('fe', 178,  4, 18);
gener-others('gr', 181, 13, 11);
gener-others('he', 179, 14, 17);
gener-others('hi', 179, 12, 15);
gener-others('jl', 180,  6, 14);
gener-others('jc', 181, 18, 18);
gener-others('pe', 179, 16,  9);
gener-others('pa', 181, 13, 17);
say '-' x 50;
say '08-conv-old.rakutest variable @data-maya';
gener-maya('m0', 181, 19,  3);
gener-maya('m1', 181,  7,  4);
gener-maya('m2', 180, 13, 14);
gener-maya('a0', 179, 16,  5);
gener-maya('a1', 178, 15, 14);
say '-' x 50;
say '09-conv-new.rakutest variable @data';
say @new-others.join("");
say '-' x 50;
say '09-conv-new.rakutest variable @data-maya';
say @new-maya.join("");

sub gener-others($key, $year, $month, $day) {
  my Date::Calendar::Bahai $db1 .= new(year => $year, month => $month, day => $day);
  my Date::Calendar::Bahai $db0 .= new-from-daycount($db1.daycount - 1);
  my     $d0  = $db0.to-date(%class{$key});
  my     $d1  = $db1.to-date(%class{$key});
  my Str $s0  = $d0 .strftime('"%A %d %b %Y"');
  my Str $s1  = $d1 .strftime('"%A %d %b %Y"');
  my Str $sb0 = $db0.strftime('"%a %d %b %Y ☼"');
  my Str $sb1 = $db1.strftime('"%a %d %b %Y ☼"');
  my Str $gr0 = $db0.to-date.gist;
  my Str $gr1 = $db1.to-date.gist;
  my Int $lg-s1 = 30;
  my Int $lg-sb = 19;
  if $s0 .chars < $lg-s1 { $s0  ~= ' ' x ($lg-s1 - $s0 .chars); }
  if $s1 .chars < $lg-s1 { $s1  ~= ' ' x ($lg-s1 - $s1 .chars); }
  if $sb0.chars < $lg-sb { $sb0 ~= ' ' x ($lg-sb - $sb0.chars); }
  if $sb1.chars < $lg-sb { $sb1 ~= ' ' x ($lg-sb - $sb1.chars); }
  my Str $day-x   = sprintf("%2d", $day);
  my Str $month-x = sprintf("%2d", $month);
  print qq:to<EOF>;
       , ($year, $month-x, $day-x, after-sunset,   '$key', $s0, $sb0, "$gr0 shift to previous day")
       , ($year, $month-x, $day-x, before-sunrise, '$key', $s1, $sb1, "$gr1 shift to daylight")
       , ($year, $month-x, $day-x, daylight,       '$key', $s1, $sb1, "$gr1 no problem")
  EOF
  $s0  = $d0 .strftime( '%A %d %b %Y' );
  $s1  = $d1 .strftime( '%A %d %b %Y' );
  $sb1 = $db1.strftime("%a %d %b %Y");
  my Int $lg = 26;
  my Str $w0 = ''; if $s0.chars < $lg { $w0 = ' ' x ($lg - $s0.chars); }
  my Str $w1 = ''; if $s1.chars < $lg { $w1 = ' ' x ($lg - $s1.chars); }
  if %midnight{$key} {
    push @new-others, qq:to<EOF>;
         , ($year, $month-x, $day-x, after-sunset,   '$key', "$s0 ☽"$w0, "$sb1 ☽", "Gregorian: $gr0")
         , ($year, $month-x, $day-x, before-sunrise, '$key', "$s1 ☾"$w1, "$sb1 ☾", "Gregorian: $gr1")
         , ($year, $month-x, $day-x, daylight,       '$key', "$s1 ☼"$w1, "$sb1 ☼", "Gregorian: $gr1")
    EOF
  }
  else {
    push @new-others, qq:to<EOF>;
         , ($year, $month-x, $day-x, after-sunset,   '$key', "$s1 ☽"$w1, "$sb1 ☽", "Gregorian: $gr0")
         , ($year, $month-x, $day-x, before-sunrise, '$key', "$s1 ☾"$w1, "$sb1 ☾", "Gregorian: $gr1")
         , ($year, $month-x, $day-x, daylight,       '$key', "$s1 ☼"$w1, "$sb1 ☼", "Gregorian: $gr1")
    EOF
  }
}

sub gener-maya($key, $year, $month, $day) {
  my Date::Calendar::Bahai $db1 .= new(year => $year, month => $month, day => $day);
  my Date::Calendar::Bahai $db0 .= new-from-daycount($db1.daycount - 1);
  my Date::Calendar::Bahai $db2 .= new-from-daycount($db1.daycount + 1);
  my Str $sb0 = $db0.strftime('"%a %d %b %Y ☼"');
  my Str $sb1 = $db1.strftime('"%a %d %b %Y ☼"');
  my     $d0  = $db0.to-date(%class{$key});
  my     $d1  = $db1.to-date(%class{$key});
  my     $d2  = $db2.to-date(%class{$key});
  my Str $s0  = $d0 .strftime('"%e %B %V %A"');
  my Str $s1  = $d1 .strftime('"%e %B %V %A"');
  my Str $l0  = $d0 .strftime( '%e %B ') ~ $d1.strftime( '%V %A');
  my Str $gr0 = $db0.to-date.gist;
  my Str $gr1 = $db1.to-date.gist;
  my Int $lg-s1 = 29;
  my Int $lg-sb = 19;
  if $s1 .chars < $lg-s1 { $s1  ~= ' ' x ($lg-s1 - $s1 .chars); }
  if $s0 .chars < $lg-s1 { $s0  ~= ' ' x ($lg-s1 - $s0 .chars); }
  if $sb1.chars < $lg-sb { $sb1 ~= ' ' x ($lg-sb - $sb1.chars); }
  if $sb0.chars < $lg-sb { $sb0 ~= ' ' x ($lg-sb - $sb0.chars); }
  my Str $day-x   = sprintf("%2d", $day);
  my Str $month-x = sprintf("%2d", $month);
  print qq:to<EOF>;
       , ($year, $month-x, $day-x, after-sunset,   '$key', $s0, $sb0, "$gr0 shift to the previous date, wrong clerical date, should be $l0")
       , ($year, $month-x, $day-x, before-sunrise, '$key', $s1, $sb1, "$gr1 wrong intermediate date, should be $l0")
       , ($year, $month-x, $day-x, daylight,       '$key', $s1, $sb1, "$gr1 no problem")
  EOF

  my Str $sbz = $db1.strftime('"%a %d %b %Y ☽"');
  $sb0        = $db1.strftime('"%a %d %b %Y ☾"');
  $sb1        = $db1.strftime('"%a %d %b %Y ☼"');
  $s0         = $d0 .strftime('"%e %B ') ~ $d1.strftime('%V %A"');
  $s1         = $d1 .strftime('"%e %B %V %A"');
  if $s0 .chars < $lg-s1 { $s0  ~= ' ' x ($lg-s1 - $s0 .chars); }
  if $s1 .chars < $lg-s1 { $s1  ~= ' ' x ($lg-s1 - $s1 .chars); }
  if $sbz.chars < $lg-sb { $sbz ~= ' ' x ($lg-sb - $sbz.chars); }
  if $sb0.chars < $lg-sb { $sb0 ~= ' ' x ($lg-sb - $sb0.chars); }
  if $sb1.chars < $lg-sb { $sb1 ~= ' ' x ($lg-sb - $sb1.chars); }
  push @new-maya, qq:to<EOF>;
       , ($year, $month-x, $day-x, after-sunset,   '$key', $s0, $sbz, "Gregorian: $gr0")
       , ($year, $month-x, $day-x, before-sunrise, '$key', $s0, $sb0, "Gregorian: $gr1")
       , ($year, $month-x, $day-x, daylight,       '$key', $s1, $sb1, "Gregorian: $gr1")
  EOF
}

=begin pod

=head1 NAME

gener-test-0.1.0.raku -- Generation of test data

=head1 SYNOPSIS

  raku gener-test-0.1.0.raku > /tmp/test-data

copy-paste from /tmp/test-data to the tests scripts.

=head1 DESCRIPTION

This  program  uses  the  various  C<Date::Calendar::>R<xxx>  classes,
version 0.0.x and  API 0, to generate test data  for version 0.1.0 and
API 1 of the modules for the  Baháʼí calendar. After the test data are
generated, check them  with another source (the  calendar functions in
Emacs, some  websites, some  Android apps).  Please remember  that the
other sources do not care about sunset (and sunrise for the civil Maya
and Aztec  calendars) and  that you  will have  to mentally  shift the
results before the comparison.

And after  the data are  checked, copy-paste  the lines into  the test
scripts   C<08-conv-old.rakutest>   and   C<09-conv-new.rakutest>   as
described in the label just above the data lines.

=head2 Maya (and Aztec) dates

Just cut-and-paste  the lines into  the C<@data-maya> variable  of the
proper test file. Erase the comma in the first pasted line.

=head2 Other dates, C<08-conv-old.rakutest>

Cut and past  the lines into the C<@data> variable  of the proper test
file.  Then,  from  this  variable,  select  the  lines  dealing  with
Gregorian dates,  cut-and-paste them into the  C<@data-greg> variable.
At the  end of  each line  dealing with  a Gregorian  date, add  a 9th
element,  which  is  the  Gregorian date  in  C<'YYYY-MM-DD'>  format.
Lastly, cut (and  do not paste) the lines for  the Baháʼí calendar and
its astronomical variant (which cannot be simultaneously version 0.0.2
and version 0.1.0).

Remove the first comma in the C<@data-greg> and C<@data> variables.

=head2 Other dates, C<09-conv-new.rakutest>

Cut and past  the lines into the C<@data> variable  of the proper test
file. Erase the comma at the beginning of the variable.

All computed  dates are daylight  dates. So  it does not  matter which
version  and API  are  such  and such  classes.  Daylight dates  gives
exactly the  same results with version  0.1.0 / API 1  as with version
0.0.x / API 0.

=head1 AUTHOR

Jean Forget <J2N-FORGET at orange dot fr>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2024, 2025 Jean Forget, all rights reserved

This program is  free software; you can redistribute  it and/or modify
it under the Artistic License 2.0.

=end pod
