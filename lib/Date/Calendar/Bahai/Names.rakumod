use v6.d;
unit module Date::Calendar::Bahai::Names:ver<0.1.1>:auth<zef:jforget>:api<1>;

my %month-names = 'ar' => ( "Bahá"     , "Jalál"  , "Jamál" , "‘Aẓamat"   , "Núr"
                          , "Rahmat"   , "Kalimát", "Kamál" , "Asmá'"     , "'Izzat"
                          , "Mashíyyat", "'Ilm"   , "Qudrat", "Qawl"      , "Masá'il"
                          , "Sharaf"   , "Sultán" , "Mulk"  , "Ayyám-i-Há", "'Alá"
                         )
                , 'en' => ( "Splendour", "Glory"      , "Beauty"    , "Grandeur"      , "Light"
                          , "Mercy"    , "Words"      , "Perfection", "Names"         , "Might"
                          , "Will"     , "Knowledge"  , "Power"     , "Speech"        , "Questions"
                          , "Honour"   , "Sovereignty", "Dominion"  , "The Days of Há", "Loftiness"
                          )
                , 'fr' => ( "Gloire"    , "Splendeur"   , "Beauté"    , "Grandeur"   , "Lumière"
                         , "Miséricorde", "Paroles"     , "Perfection", "Noms"       , "Puissance"
                         , "Volonté"    , "Connaissance", "Pouvoir"   , "Discours"   , "Questions"
                         , "Honneur"    , "Souveraineté", "Empire"    , "Jours de Há", "Élévation"
                         ) ;

my %month-abbr  = 'ar' => < Bah Jal Jam Aza Nur Rah Kal Kal Asm Izz Mat Ilm Qud Qaw Mal Sha Sul Mul Ayy Ala >
                , 'en' => < Glo Spl Bea Gra Lig Mer Wor Per Nam Mig Wil Kno Pow Spe Que Hon Sov Dom Add Lof >
                , 'fr' => < Glo Spl Bea Gra Lum Mis Par Per Nom Pui Pou Vol Cnn Dis Que Hon Sou Emp Int Ele >
;

my %day-names  =  'ar' => <  Jalál    Jamál    Kamál      Fiḍál    ʻIdál    Istijlál    Istiqlál     >
                , 'en' => <  Glory    Beauty   Perfection Grace    Justice  Majesty     Independence >
                , 'fr' => <  Gloire   Beauté   Perfection Grâce    Justice  Majesté     Indépendance >
;

my %day-abbr  =   'ar' => < Jal Jam Kam Fid Ida Isj Isq >
                , 'en' => < Glo Bea Per Gra Jus Maj Ind >
                , 'fr' => < Glo Bea Per Gra Jus Maj Ind >
;

my %cycle-year-names = 'ar' => < Alif   Bá'   Ab   Dál    Báb
                                 Váv    Abad  Jád  Bahá   Ḥubb
                                 Bahháj Javáb Aḥad Vahháb Vidád
                                 Badíʿ  Bahí  Abhá Váḥid
                               >
                     , 'en' => ( "A"         , "B"       , "Father"       , "D"        , "Gate"
                               , "V"         , "Eternity", "Generosity"   , "Splendour", "Love"
                               , "Delightful", "Answer"  , "Single"       , "Bountiful", "Affection"
                               , "Beginning" , "Luminous", "Most Luminous", "Unity"
                               )
                     , 'fr' => ( "A"        , "B"        , "Père"          , "D"        , "Porte"
                               , "V"        , "Éternité" , "Générosité"    , "Splendeur", "Amour"
                               , "Délicieux", "Réponse"  , "Unique"        , "Libéral"  , "Affection"
                               , "Début"    , "Splendide", "Plus Splendide", "Unité"
                               );


our sub allowed-locale(Str:D $locale) {
  %month-names{$locale}:exists;
}

our sub month-name(Str:D $locale, Int:D $month --> Str) {
  %month-names{$locale}[$month - 1];
}

our sub month-abbr(Str:D $locale, Int:D $month --> Str) {
  %month-abbr{$locale}[$month - 1];
}

our sub day-name(Str:D $locale, Int:D $index --> Str) {
  %day-names{$locale}[$index - 1];
}

our sub day-abbr(Str:D $locale, Int:D $index --> Str) {
  %day-abbr{$locale}[$index - 1];
}

our sub cycle-year-name(Str:D $locale, Int:D $index --> Str) {
  %cycle-year-names{$locale}[$index - 1];
}


=begin pod

=head1 NAME

Date::Calendar::Bahai::Names - string values for the Baháʼí calendar

=head1 SYNOPSIS

=begin code :lang<raku>

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

L<Date::Bahai::Simple|https://metacpan.org/pod/Date::Bahai::Simple>

=head2 Other Software

date(1), strftime(3)

C<calendar/cal-bahai.el>  in emacs  or xemacs.

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
(website no longer works).

L<https://en.wikipedia.org/wiki/Bah%C3%A1%27%C3%AD_calendar>

L<https://icalendrier.fr/calendriers-saga/calendriers/baha-i> (in French)

=head1 AUTHOR

Jean Forget <J2N-FORGET at orange dot fr>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2021, 2024, 2025 Jean Forget, all rights reserved

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
