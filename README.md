NAME
====

Date::Calendar::Bahai - Conversions from / to the Baháʼí calendar

SYNOPSIS
========

```raku
use Date::Calendar::Bahai;
my Date $dt-greg;
my Date::Calendar::Bahai $dt-bahai;

$dt-greg  .= new(2021, 5, 17);
$dt-bahai .= new-from-date($dt-greg);

say $dt-bahai;
# --> 0178-04-01
say $dt-bahai.strftime("%A %d %B %Y");
# --> Kamál 1 ‘Aẓamat 178
```

Converting a Bahai date (e.g. 19 Jamál 178) into Gregorian

```raku
use Date::Calendar::Bahai;
my Date::Calendar::Bahai $dt-bahai;
my Date $dt-greg;

$dt-bahai .= new(year => 178, month => 3, day => 19);
$dt-greg   = $dt-bahai.to-date;

say $dt-greg;
# --> 2021-05-16
```

DESCRIPTION
===========

Date::Calendar::Bahai  is a  class  representing dates  in the  Baháʼí
calendar. It  allows you to  convert a  Baháʼí date into  Gregorian or
into other implemented  calendars, and it allows you  to convert dates
from Gregorian or from other calendars into Baháʼí.

The Date::Calendar::Bahai class gives the  early version of the Baháʼí
calendar, which is  synchronised with the Gregorian  calendar. The new
version,  after   the  2015   reform,  is  partially   implemented  in
Date::Calendar::Bahai::Astronomical, included in this distribution.

INSTALLATION
============

```shell
zef install Date::Calendar::Bahai
```

or

```shell
git clone https://github.com/jforget/raku-Date-Calendar-Bahai.git
cd raku-Date-Calendar-Bahai
zef install .
```

AUTHOR
======

Jean Forget <J2N-FORGET at orange dot fr>

COPYRIGHT AND LICENSE
=====================

Copyright 2021, 2024, 2025 Jean Forget

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

