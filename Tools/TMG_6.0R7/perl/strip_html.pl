#/usr/bin/perl -w
#!/usr/bin/perl -w
# strip_html.pl is a perl implementation of the MATLAB strip_html function. 
#
# Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

use strict;

my $filename=$ARGV[0];
my $ext=0;
my ($contents, $line, $i);
my (@con, @con1);
local $/='';

# input file must have an '.html' or '.htm' suffix
if ($filename=~m/\.htm$/ or $filename=~m/\.html$/) { $ext=1; }
if ($ext==0) { print "Give an html file...\n"; exit; }
open FD, '<'.$filename or die "No such file...\n";

# applying conversion
print "Converting file $filename...\n";
$contents=<FD>; close FD;
$contents=~s/<\s*(script)(.*?)<\s*\/script\s*>//gs;
$contents=~s/<[^>|^<]*>//gs;
$contents=~s/&lt;/</gs; $contents=~s/&gt;/>/gs; $contents=~s/&nbsp;/ /gs; $contents=~s/&amp;/&/gs; $contents=~s/&quot;/ /gs;

# saving result
@con=split(/\n/, $contents); 
for $line (@con) { chomp $line; $line=~s/[^\040-\176]//g; $line=~s/\s+$//; if ($line ne '') { push @con1, $line; } }
open FD, '>'.$filename.'.txt';
#for ($i=0;$i<$#con1;$i++) { if ($con1[$i] ne '') { print FD $con1[$i], "\n"; } } close FD;
$,="\n"; print FD @con1; close FD;