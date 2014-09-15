#!/usr/bin/perl -w
# stemmer.pl is an interface to the Stemmer module. 
#
# Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

use lib $ARGV[0];
use Stemmer;

$filename=$ARGV[1];
open FD, '<'.$filename;

#$tokens=<FD>;
#@tokens=split(/\s+/, $tokens); 
#print $#tokens+1, "\n";
@tokens=<FD>;

for ($i=0;$i<$#tokens+1;$i++) {
	chomp $tokens[$i];
	$tokens[$i]=Stemmer::stemmer_fun($tokens[$i], 0);
}

$,="\n";
close FD; open FD, '>'.$filename;
print FD @tokens;
close FD; 