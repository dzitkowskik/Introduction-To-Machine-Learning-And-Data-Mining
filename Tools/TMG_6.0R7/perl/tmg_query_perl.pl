#!/usr/bin/perl -w
# tmg_query_perl.pl is a perl implementation of the MATLAB tmg_query function. 
#
# Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

use lib $ARGV[0];
use strict;
use Stemmer;

my $sp1; 
my $sp2; 
my $delimiter;
my $line_delimiter;
my $stoplist;
my $use_stoplist;
my @stopwords;
my $word;
my $stemming;
my $remove_num;
my $remove_al;
#my $min_length;
#my $max_length;
my $filename;
my @files;
my %inv_index;
my $doc_id;
my @words_per_doc;
my $file;
my @ar;
my @new_doc;
my $i;
my $cnt;
my $chunk;
my $j;
my $jj;
my @words;
#my $rem_stoplist;
#my $rem_terms_length;
#my $rem_stemming;
my %tmp;
my $token;
my $stemmed_token;
my @docs;
my $doc;
my @keys;
my @values;
my $display_filename;
my $dsp;

open FILE_DICT, ">dict.tmp";
open FILE_TITLES, ">titles.tmp";

$delimiter=$ARGV[1]; 
$line_delimiter=$ARGV[2];
$stoplist=$ARGV[3];
$stemming=$ARGV[4]+0;
#$min_length=$ARGV[5]+0; 
#$max_length=$ARGV[6]+0;
$filename=$ARGV[5]; 
$dsp=$ARGV[6]+0;
$remove_num=$ARGV[7]+0;
$remove_al=$ARGV[8]+0;

$sp1='ltspcl'; $sp2='gtspcl'; $delimiter=~s/$sp1/</g; $delimiter=~s/$sp2/>/g; 
$use_stoplist=1; if ($stoplist eq '-nostoplist') { $use_stoplist=0; } 
open FILE_STOPLIST, '<'.$stoplist or $use_stoplist=0;
if ($use_stoplist!=0) { 
	@stopwords=map {lc($_);} <FILE_STOPLIST>; close FILE_STOPLIST; 
	for $word (@stopwords) {
		chomp $word; if ($word=~ /\r$/) { chop($word); }
	}
}
open FF, '<'.$filename; @files=<FF>; close FF; $cnt=0; for $file (@files) { chomp $file; $files[$cnt++]=$file; }
if ($delimiter eq 'none_delimiter' or $delimiter eq 'emptyline') {
	$line_delimiter='1';
}
$line_delimiter=$line_delimiter+0;
if ($delimiter eq 'emptyline') { 
	$delimiter='';
}

%inv_index=();
$doc_id=0;
@words_per_doc=();
for $file (@files) {
	$display_filename=$file; $display_filename=~s/\\/\//; 
	if ($dsp==1) { print "=================================================================================\nParsing file $display_filename...\n=================================================================================\n"; }
	open FILE, '<'.$file;
	if ($line_delimiter==1) {
		$delimiter=lc($delimiter);
		@ar=map {lc($_);} <FILE>;
		unshift @ar, '';
		
		@new_doc=(1);
		if ($delimiter eq 'none_delimiter') {
			for ($i=1;$i<$#ar+1;$i++) { $new_doc[$i]=0; }
			$cnt=1;
			for $chunk (@ar[1..$#ar]) {
				chomp $chunk;
				if ($chunk =~ /\r$/) {
					chop($chunk);
				}
				while ($chunk=~m/\s$/) { chop $chunk; }
				$chunk =~ s/~|`|!|@|#|\$|%|\^|&|\*|\(|\)|-|_|=|\+|\[|\]|{|}|\\|\||:|;|'|"|<|>|\?|\/|,|\.‘|’|“|”/ /g; 
				$chunk =~ s/^\s+//;
				$ar[$cnt++]=$chunk;
			}			
		} else {
			$cnt=1;
			for $chunk (@ar[1..$#ar]) {
				chomp $chunk;
				if ($chunk =~ /\r$/) {
					chop($chunk);
				}
				while ($chunk=~m/\s$/) { chop $chunk; }
				if ($chunk eq $delimiter) {
					$new_doc[$cnt]=1; 
					if ($new_doc[$cnt-1]==1 or $new_doc[$cnt-1]==-1) {
						$new_doc[$cnt]=-1;
					}
				} else {
					$new_doc[$cnt]=0;
				}
				$chunk =~ s/~|`|!|@|#|\$|%|\^|&|\*|\(|\)|-|_|=|\+|\[|\]|{|}|\\|\||:|;|'|"|<|>|\?|\/|,|\.‘|’|“|”/ /g; 
				$chunk =~ s/^\s+//;
				$ar[$cnt++]=$chunk;
			}
		}
	
		for ($i=0;$i<$#new_doc;$i++) {
			if ($new_doc[$i]==1) {
				$doc_id++; $words_per_doc[$doc_id-1]=0;
				if ($dsp==1) { print "Parsing query $doc_id...\n"; }
				if ($i==0 and $new_doc[1]==-1) { for ($jj=2;$jj<$#new_doc+1;$jj++) { if ($new_doc[$jj]==0) { last; } } } else { $jj=$i+1; }
				if (length($ar[$jj])>50) { print FILE_TITLES $file, '.', $doc_id, "\n\t", substr($ar[$jj], 0, -length($ar[$jj])+50), "\n"; } else { print FILE_TITLES $file, '.', $doc_id, "\n\t", $ar[$jj], "\n"; }
				#print FILE_TITLES $file, '.', $doc_id, "\n\t", $ar[$jj], "\n"; 
				for ($j=$i+1;$j<$#new_doc+1;$j++) {
					if ($j==$i+1 and $new_doc[$j]==1) {
						$doc_id--;
						last;
					}
					if ($new_doc[$j]==-1){ 
						next; 
					}
					if ($new_doc[$j]==1) {
						if ($dsp==1) { print "\tNumber of terms: $words_per_doc[$doc_id-1]...\n"; }
						last;
					}
					@words=split(/\s+/, $ar[$j]); $words_per_doc[$doc_id-1]+=$#words+1;
					for $word (@words) {
						$inv_index{$word}{$doc_id}+=1;
					}
				}
			}
		}
		if ($new_doc[$#new_doc]==0) { if ($dsp==1) { print "\tNumber of terms: $words_per_doc[$doc_id-1]...\n"; } }
	} 
	else {
		$/=$delimiter;
		@ar=map {lc($_);} <FILE>;
		for ($i=0;$i<$#ar+1;$i++) {
			if (length($ar[$i])>50) { print FILE_TITLES $file, '.', $doc_id, "\n\t", substr($ar[$i], 0, -length($ar[$i])+50), "\n"; } else { print FILE_TITLES $file, '.', $doc_id, "\n\t", $ar[$i], "\n"; }
			$chunk=$ar[$i];
			$chunk =~ s/~|`|!|@|#|\$|%|\^|&|\*|\(|\)|-|_|=|\+|\[|\]|{|}|\\|\||:|;|'|"|<|>|\?|\/|,|\.‘|’|“|”/ /g; 
			$chunk =~ s/^\s+//;
			$ar[$i]=$chunk;
			$doc_id++; $words_per_doc[$doc_id-1]=0;
			if ($dsp==1) { print "Parsing query $doc_id...\n"; }
			@words=split(/\s+/, $ar[$i]); $words_per_doc[$doc_id-1]+=$#words+1;
			if ($#words==0) {
				$doc_id--; 
				next; 
			}
			for $word (@words) {
				$inv_index{$word}{$doc_id}+=1;
			}
			if ($dsp==1) { print "\tNumber of terms: $words_per_doc[$doc_id-1]...\n"; }
		}
	}
	close FILE;
}

#$rem_stoplist=0;
if ($use_stoplist==1) {
	if ($dsp==1) { print "Removing stopwords...\n"; }
	for $word (@stopwords) {
		if (exists($inv_index{$word})) { delete $inv_index{$word}; }
	}
}

#$rem_terms_length=0;
if ($remove_num==1){if ($dsp==1) { print "=================================================================================\nRemoving numbers...\n"; } }
if ($remove_al==1){if ($dsp==1) { print "=================================================================================\nRemoving alphanumerics...\n"; } }
if ($dsp==1) { print "Normalizing the dictionary...\n=================================================================================\n"; }
for $word (keys %inv_index) {
	if ($remove_num==1){ 
		if ($word =~ m/^\d+$/ ) {
			delete $inv_index{$word};
			next;
		}
	}
	if ($remove_al==1){
		if ($word =~ m/\d+/){
			if ($remove_num==1){
				delete $inv_index{$word};
				next;
			}
			else{
				if($word !~ m/^\d+$/ ){
					delete $inv_index{$word};
					next;
				}
			}
		}
	}
#	if (length($word)<$min_length or length($word)>$max_length) {
#		delete $inv_index{$word};
#		$rem_terms_length++;
#	}	
}


#$rem_stemming=0;
if ($stemming==1) {
	if ($dsp==1) { print "Applying stemming...\n=================================================================================\n"; }
	%tmp=%inv_index;
	%inv_index=(); 
	for $token (keys %tmp) {
		$stemmed_token=Stemmer::stemmer_fun($token, 0);
		if (!exists($inv_index{$stemmed_token})) {
			$inv_index{$stemmed_token}=$tmp{$token};
		} else {
#			$rem_stemming++;
			@docs=keys %{$tmp{$token}}; 
			for $doc (@docs) {
				$inv_index{$stemmed_token}{$doc}+=$tmp{$token}{$doc};
			}
		}
	}
}

#print "Number of terms = ", scalar keys(%inv_index), "\n";
#print "Number of documents = ", $doc_id, "\n";



$,="\n";
print FILE_DICT sort keys %inv_index;

open FILE_DICT1, '>dict1.tmp';
$cnt=0;
for $word (sort keys %inv_index) {
	$cnt++;
	@keys=keys %{$inv_index{$word}};
	@values=values %{$inv_index{$word}};
	for ($i=0;$i<$#keys+1;$i++) {
		print FILE_DICT1 "$cnt $keys[$i] $values[$i]\n";
	}
}
open FILE_WPD, '>wpd.tmp';
#print FILE_WPD "$rem_stoplist\n$rem_stemming\n$rem_terms_length\n";
$,="\n"; print FILE_WPD @words_per_doc; close FILE_WPD;
close FILE_DICT;
close FILE_TITLES;
close FILE_DICT1;