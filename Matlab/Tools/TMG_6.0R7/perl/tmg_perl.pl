#!/usr/bin/perl -w
# tmg_perl.pl is a perl implementation of the MATLAB tmg function. 
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
my $remove_num;
my $remove_al;
my @tmp_stopwords;
my %stopwords;
my $word;
my $stemming;
my $min_length;
my $max_length;
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
my $rem_stoplist;
my $rem_terms_length;
my $rem_stemming;
my $rem_numbers;
my $rem_alphanumerics;
#my %tmp;
#my $token;
#my $stemmed_token;
#my @docs;
my $doc;
#my @keys;
my @values;
my $display_filename;
my $dsp;
my %removed_words_length;
my %removed_words_numbers;
my %removed_words_stopwords;
my %removed_words_alphanumerics;


open FILE_DICT, ">dict.tmp";
open FILE_TITLES, ">titles.tmp";

$delimiter=$ARGV[1]; 
$line_delimiter=$ARGV[2];
$stoplist=$ARGV[3];
$stemming=$ARGV[4]+0;
$min_length=$ARGV[5]+0; 
$max_length=$ARGV[6]+0;
$filename=$ARGV[7]; 
$dsp=$ARGV[8]+0;
$remove_num=$ARGV[9]+0;
$remove_al=$ARGV[10]+0;

$sp1='ltspcl'; $sp2='gtspcl'; $delimiter=~s/$sp1/</g; $delimiter=~s/$sp2/>/g; 
$use_stoplist=1; if ($stoplist eq '-nostoplist') { $use_stoplist=0; } 
open FILE_STOPLIST, '<'.$stoplist or $use_stoplist=0;
if ($use_stoplist!=0) { 
	@tmp_stopwords=map {lc($_);} <FILE_STOPLIST>; close FILE_STOPLIST; 
	for $word (@tmp_stopwords) {
		chomp $word; if ($word=~ /\r$/) { chop($word); }
		$stopwords{$word}++;
	}
	undef @tmp_stopwords;
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
open FD1, '>d1.tmp'; open FD2, '>d2.tmp'; 
for $file (@files) {
	$display_filename=$file; $display_filename=~s/\\/\//; 
	print "=================================================================================\nParsing file $display_filename...\n=================================================================================\n"; 
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
				$chunk =~ s/~|`|!|@|#|\$|%|\^|&|\*|\(|\)|-|_|=|\+|\[|\]|{|}|\\|\||:|;|'|"|<|>|\?|\/|,|\.|‘|’|“|”/ /g; 
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
				$chunk =~ s/~|`|!|@|#|\$|%|\^|&|\*|\(|\)|-|_|=|\+|\[|\]|{|}|\\|\||:|;|'|"|<|>|\?|\/|,|\.|‘|’|“|”/ /g; 
				$chunk =~ s/^\s+//;
				$ar[$cnt++]=$chunk;
			}
		}
	
		for ($i=0;$i<$#new_doc;$i++) {
			if ($new_doc[$i]==1) {
				$doc_id++; $words_per_doc[$doc_id-1]=0;
				if ($dsp==1) { print "Parsing document $doc_id...\n"; }
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
			$chunk =~ s/~|`|!|@|#|\$|%|\^|&|\*|\(|\)|-|_|=|\+|\[|\]|{|}|\\|\||:|;|'|"|<|>|\?|\/|,|\.|‘|’|“|”/ /g; 
			$chunk =~ s/^\s+//;
			$ar[$i]=$chunk;
			$doc_id++; $words_per_doc[$doc_id-1]=0;
			@words=split(/\s+/, $ar[$i]); $words_per_doc[$doc_id-1]+=$#words+1;
			if ($#words==-1) {
				$doc_id--; 
				next; 
			} else {
				if ($dsp==1) { print "Parsing document $doc_id...\n"; }
			}
			for $word (@words) {
				$inv_index{$word}{$doc_id}+=1;
			}
			if ($dsp==1) { print "\tNumber of terms: $words_per_doc[$doc_id-1]...\n"; }
		}
	}
	close FILE; @ar=(); undef @ar; 
	for $word (keys %inv_index) {
		if (exists($stopwords{$word})) { $removed_words_stopwords{$word}++; next; }
		if ($remove_num==1){if ($word =~ m/^\d+$/ ) { $removed_words_numbers{$word}++; next; }}
		if (length($word)<$min_length or length($word)>$max_length) { $removed_words_length{$word}++; next; }
		if ($remove_al==1){if ($word =~ m/\d+/){if ($remove_num==1){$removed_words_alphanumerics{$word}++;next;}else{if($word !~ m/^\d+$/ ){$removed_words_alphanumerics{$word}++;next;}}}}
		print FD1 "$word\n"; 
		for $doc (keys %{$inv_index{$word}}) {
			print FD2 "$doc $inv_index{$word}{$doc} ";
		}
		print FD2 "\n";
	}
	undef %inv_index;
}
close FD1; close FD2;
my @tmp_array1=keys %removed_words_stopwords; $rem_stoplist=@tmp_array1;
my @tmp_array2=keys %removed_words_numbers; $rem_numbers=@tmp_array2;
my @tmp_array3=keys %removed_words_length; $rem_terms_length=@tmp_array3;
my @tmp_array4=keys %removed_words_alphanumerics; $rem_alphanumerics=@tmp_array4;


my %tmp_index1; 
if ($stemming==1) {
	open FD3, '<d1.tmp'; 
	while (<FD3>) {
		$word=$_; chomp $word;
		if ($word =~ /\r$/) {
			chop($word);
		}
		$tmp_index1{$word}=0;
	}
	close FD3;
}
open FD1, '<d1.tmp'; open FD2, '<d2.tmp'; open FD3, '>d3.tmp';
my $word1; 
$cnt=0; $rem_stemming=0;
while (<FD1>) {
	$word=$_; chomp $word;
	if ($word =~ /\r$/) {
		chop($word);
	}
	if ($stemming==1) { 
		$word1=Stemmer::stemmer_fun($word, 0); 
		if (exists($inv_index{$word1}) and $tmp_index1{$word}==0) {
			$rem_stemming++;
		}
		$tmp_index1{$word}=1; $word=$word1;
	}
	$word1=<FD2>; chomp $word1;
	if ($word1 =~ /\r$/) {
		chop($word1);
	}	

	if (exists($inv_index{$word})) { print FD3 $word1.$inv_index{$word}, "\n"; } else { $cnt++; $inv_index{$word}=$cnt; print FD3 $word1.$cnt, "\n"; }
}
close FD1; close FD2; close FD3; 
unlink("d1.tmp"); unlink("d2.tmp"); 


$,="\n";
print FILE_DICT sort keys %inv_index;
open FILE_WORD_IDS, '>word_ids.tmp';
for $word (sort keys %inv_index) {
	print FILE_WORD_IDS $inv_index{$word}, "\n";
}

open FILE_MATRIX, '>matrix.tmp';
open FD3, '<d3.tmp';
while (<FD3>) {
	$word=$_; chomp $word;
		if ($word =~ /\r$/) {
			chop($word);
	}
	@values=split(/\s+/, $word); $cnt=$values[$#values];
	for ($i=0;$i<$#values;$i+=2) {
		print FILE_MATRIX "$cnt $values[$i] $values[$i+1]\n";
	}	
}
close FD3; close FILE_WORD_IDS; 
unlink("d3.tmp");

open FILE_WPD, '>wpd.tmp';
print FILE_WPD "$rem_stoplist\n$rem_stemming\n$rem_terms_length\n";
$,="\n"; print FILE_WPD @words_per_doc; close FILE_WPD;
close FILE_DICT;
close FILE_TITLES;
close FILE_MATRIX;