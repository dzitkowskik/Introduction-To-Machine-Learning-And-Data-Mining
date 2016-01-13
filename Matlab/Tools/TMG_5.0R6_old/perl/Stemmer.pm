#!/usr/bin/perl -w
# Stemmer.pm is a perl module implementing the Porter stemming algorithm [1].
#
# REFERENCES:
# [1] M.F.Porter, An algorithm for suffix stripping, Program, 14(3): 130-137,
# 1980.
# 
# Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

use strict; 

package Stemmer;

sub get_signature($)
{
	my $token=$_[0];
	my $n=length($token);
	my $signature='';
	my $i=0;
	my $c; 
	my $c1;
	
	for ($i=0;$i<$n;$i++) {
		if ($i==0) { $c=substr($token, 0, -length($token)+1); } else { $c=substr($token, $i, -length($token)+$i+1); }
		if ($c eq 'a' or $c eq 'e' or $c eq 'i' or $c eq 'o' or $c eq 'u') { 
			$signature=$signature.'v'; 
		} else {
			if ($c eq 'y' and $i==0) { $signature=$signature.'c'; next; }
			$c1='';
			if ($i==1) { $c1=$signature; } elsif ($i>1) {$c1=substr($signature, $i-1); }
			if ($c eq 'y' and $c1 eq 'c') { $signature=$signature.'v'; } else { $signature=$signature.'c'; }
		}
	}
	return $signature; 
}

sub get_m(@)
{
	my ($signature, $n)=@_;
	if ($n<length($signature)) { $signature=substr($signature, 0, -length($signature)+$n); }
	my $sign=substr($signature, 0, -length($signature)+1);
	my $i;
	my $cur=1;
	my $c;
	my $c1;
	
	for ($i=1;$i<length($signature);$i++) {
		if ($i==length($signature)-1) { $c=substr($signature, $i); } else { $c=substr($signature, $i, -length($signature)+$i+1); }
		$c1=substr($sign, length($sign)-1);
		if ($c1 ne $c) {
			$sign=$sign.$c; $cur++;
		}
	}
	my $res=($sign=~s/vc/vc/g); if ($res eq '') { $res=0; }
	return $res;
}

sub stemmer_fun(@) {
	my ($token, $dsp)=@_;
	my ($m1, $m2, $m3, $m4, $m5, $m6, $m7);
	$token=lc($token);
	if ($dsp!=0) { $dsp=1; }

	my $n=length($token);

	if ($token=~ m/\d/ or $n<3) { return $token; }

	my $signature=get_signature($token);
	if ($dsp==1) { print "signature = $signature\n"; }

	# step 1a
	my $flag=0;
	if ($n>=4) { 
		if ($token=~ m/sses$/) { $token=substr($token, 0, -2); $signature=substr($signature, 0, -2); $flag=1; } 
	} 
	if ($n>=3 and $flag==0) {
		if ($token=~ m/ies$/) { $token=substr($token, 0, -2); $signature=substr($signature, 0, -2); $flag=1; } 
	} 
	if ($n>=2 and $flag==0) {
		if ($token=~ m/ss$/) { $flag=1; } 	
	} 
	if ($flag==0) {
		if ($token=~ m/s$/) { $token=substr($token, 0, -1); $signature=substr($signature, 0, -1); }
	}
	if ($dsp==1) { print "After step 1a: $token\n"; }

	#Step 1b
	my $m;
	my $c; 
	my $c1;
	my $c2;
	$n=length($token); 
	$flag=0;
	my $flag1=0;
	if ($n>3) { 
		$m=get_m($signature, $n-3);
		if ($m>0 and $token=~m/eed$/) { $token=substr($token, 0, -1); $signature=substr($signature, 0, -1); $flag=1; }
	} 
	if ($n>2 and $flag==0) { 
		$c=substr($signature, 0, -2); 
		$c1=substr($token, length($token)-3, -2); 
		if ($c=~m/v/ and $token=~m/ed$/ and $c1 ne 'e') { $token=substr($token, 0, -2); $signature=substr($signature, 0, -2); $flag=1; $flag1=1; }
	} 
	if ($n>3 and $flag==0) {
		$c=substr($signature, 0, -3); 
		if ($c=~m/v/ and $token=~m/ing$/) { $token=substr($token, 0, -3); $signature=substr($signature, 0, -3); $flag1=1; }
	}
	$n=length($token); 
	if ($flag1==1) {
		$flag=0;
		if ($n>1) {
			if ($token=~m/at$/ or $token=~m/bl$/ or $token=~m/iz$/) { $token=$token.'e'; $signature=$signature.'v'; $flag=1; }
			$c=substr($signature, length($signature)-1); 
			$c1=substr($token, length($token)-2, -1); 
			$c2=substr($token, length($token)-1);
			if ($flag==0 and $c eq 'c' and $c1 eq $c2 and $c2 ne 'l' and $c2 ne 's' and $c2 ne 'z') { $token=substr($token, 0, -1); $signature=substr($signature, 0, -1); $flag=1; }
		}
		$n=length($token);
		if ($n>2 and $flag==0) {
			$m=get_m($signature, $n);
			$c=substr($signature, length($signature)-3); 
			$c2=substr($token, length($token)-1);
			if ($m==1 and ($c eq 'cvc' and $c2 ne 'w' and $c2 ne 'x' and $c2 ne 'y')) { $token=$token.'e'; $signature=$signature.'v'; } 
		}
	}
	if ($dsp==1) { print "After step 1b: $token\n"; }

	#Step 1c
	$n=length($token); 
	if ($n>1) {
			$c=substr($signature, 0, -1); 
			$c2=substr($token, length($token)-1);
			if ($c=~m/v/ and $c2 eq 'y') { $token=substr($token, 0, -1); $signature=substr($signature, 0, -1); $token=$token.'i'; $signature=$signature.'v'; }
	}
	if ($dsp==1) { print "After step 1c: $token\n"; }

	#Step 2
	$n=length($token); 
	$flag=0;
	if ($n>7) {
		$m7=get_m($signature, $n-7); if ($m7>0 and $token=~m/ational$/) { $token=substr($token, 0, -5); $signature=substr($signature, 0, -4); $token=$token.'e'; $flag=1; }
	}
	if ($n>6 and $flag==0) {
		$m6=get_m($signature, $n-6); if ($m6>0 and $token=~m/tional$/) { $token=substr($token, 0, -2); $signature=substr($signature, 0, -2); $flag=1; }
	}
	if ($n>4 and $flag==0) {
		$m4=get_m($signature, $n-4); if ($m4>0 and $token=~m/enci$/) { $token=substr($token, 0, -1); $token=$token.'e'; $flag=1; }
	}
	if ($n>4 and $flag==0) {
		if ($m4>0 and $token=~m/anci$/) { $token=substr($token, 0, -1); $token=$token.'e'; $flag=1; }
	}
	if ($n>4 and $flag==0) {
		if ($m4>0 and $token=~m/izer$/) { $token=substr($token, 0, -1); $signature=substr($signature, 0, -1); $flag=1; }
	}
	#New rule
	if ($n>3 and $flag==0) {
		$m3=get_m($signature, $n-3); if ($m3>0 and $token=~m/bli$/) { $token=substr($token, 0, -1); $token=$token.'e'; $flag=1; }
	}
	if ($n>4 and $flag==0) {
		if ($m4>0 and $token=~m/alli$/) { $token=substr($token, 0, -2); $signature=substr($signature, 0, -2); $flag=1; }
	}
	if ($n>5 and $flag==0) {
		$m5=get_m($signature, $n-5); if ($m5>0 and $token=~m/entli$/) { $token=substr($token, 0, -2); $signature=substr($signature, 0, -2); $flag=1; }
	}
	if ($n>3 and $flag==0) {
		if ($m3>0 and $token=~m/eli$/) { $token=substr($token, 0, -2); $signature=substr($signature, 0, -2); $flag=1; }
	}
	if ($n>5 and $flag==0) {
		if ($m5>0 and $token=~m/ousli$/) { $token=substr($token, 0, -2); $signature=substr($signature, 0, -2); $flag=1; }
	}
	if ($n>7 and $flag==0) {
		if ($m7>0 and $token=~m/ization$/) { $token=substr($token, 0, -5); $signature=substr($signature, 0, -4); $token=$token.'e'; $flag=1; }
	}
	if ($n>5 and $flag==0) {
		if ($m5>0 and $token=~m/ation$/) { $token=substr($token, 0, -3); $signature=substr($signature, 0, -2); $token=$token.'e'; $flag=1; }
	}
	if ($n>4 and $flag==0) {
		if ($m4>0 and $token=~m/ator$/) { $token=substr($token, 0, -2); $signature=substr($signature, 0, -1); $token=$token.'e'; $flag=1; }
	}
	if ($n>5 and $flag==0) {
		if ($m5>0 and $token=~m/alism$/) { $token=substr($token, 0, -3); $signature=substr($signature, 0, -3); $flag=1; }
	}
	if ($n>7 and $flag==0) {
		if ($m7>0 and $token=~m/iveness$/) { $token=substr($token, 0, -4); $signature=substr($signature, 0, -4); $flag=1; }
	}
	if ($n>7 and $flag==0) {
		if ($m7>0 and $token=~m/fulness$/) { $token=substr($token, 0, -4); $signature=substr($signature, 0, -4); $flag=1; }
	}
	if ($n>7 and $flag==0) {
		if ($m7>0 and $token=~m/ousness$/) { $token=substr($token, 0, -4); $signature=substr($signature, 0, -4); $flag=1; }
	}
	if ($n>5 and $flag==0) {
		if ($m5>0 and $token=~m/aliti$/) { $token=substr($token, 0, -3); $signature=substr($signature, 0, -3); $flag=1; }
	}
	if ($n>5 and $flag==0) {
		if ($m5>0 and $token=~m/iviti$/) { $token=substr($token, 0, -3); $signature=substr($signature, 0, -2); $token=$token.'e'; $flag=1; }
	}
	if ($n>6 and $flag==0) {
		if ($m6>0 and $token=~m/biliti$/) { $token=substr($token, 0, -5); $signature=substr($signature, 0, -5); $token=$token.'le'; $signature=$signature.'cv'; $flag=1; }
	}
	#New rule
	if ($n>4 and $flag==0) {
		if ($m4>0 and $token=~m/logi$/) { $token=substr($token, 0, -1); $signature=substr($signature, 0, -1); $flag=1; }
	}
	if ($dsp==1) { print "After step 2: $token\n"; }

	#Step 3
	$n=length($token); 
	$flag=0;
	if ($n>5) {
		$m5=get_m($signature, $n-5); if ($m5>0 and $token=~m/icate$/) { $token=substr($token, 0, -3); $signature=substr($signature, 0, -3); $flag=1; }
	}
	if ($n>5 and $flag==0) {
		if ($m5>0 and $token=~m/ative$/) { $token=substr($token, 0, -5); $signature=substr($signature, 0, -5); $flag=1; }
	}
	if ($n>5 and $flag==0) {
		if ($m5>0 and $token=~m/alize$/) { $token=substr($token, 0, -3); $signature=substr($signature, 0, -3); $flag=1; }
	}
	if ($n>5 and $flag==0) {
		if ($m5>0 and $token=~m/iciti$/) { $token=substr($token, 0, -3); $signature=substr($signature, 0, -3); $flag=1; }
	}
	if ($n>4 and $flag==0) {
		$m4=get_m($signature, $n-4); if ($m4>0 and $token=~m/ical$/) { $token=substr($token, 0, -2); $signature=substr($signature, 0, -2); $flag=1; }
	}
	if ($n>3 and $flag==0) {
		$m3=get_m($signature, $n-3); if ($m3>0 and $token=~m/ful$/) { $token=substr($token, 0, -3); $signature=substr($signature, 0, -3); $flag=1; }
	}
	if ($n>4 and $flag==0) {
		if ($m4>0 and $token=~m/ness$/) { $token=substr($token, 0, -4); $signature=substr($signature, 0, -4); $flag=1; }
	}
	if ($dsp==1) { print "After step 3: $token\n"; }

	#Step 4
	$n=length($token); 
	$flag=0;
	if ($n>2) {
		$m2=get_m($signature, $n-2); if ($m2>1 and $token=~m/al$/) { $token=substr($token, 0, -2); $signature=substr($signature, 0, -2); $flag=1; }
	}
	if ($n>4 and $flag==0) {
		$m4=get_m($signature, $n-4); if ($m4>1 and $token=~m/ance$/) { $token=substr($token, 0, -4); $signature=substr($signature, 0, -4); $flag=1; }
	}
	if ($n>4 and $flag==0) {
		if ($m4>1 and $token=~m/ence$/) { $token=substr($token, 0, -4); $signature=substr($signature, 0, -4); $flag=1; }
	}
	if ($n>2 and $flag==0) {
		if ($m2>1 and $token=~m/er$/) { $token=substr($token, 0, -2); $signature=substr($signature, 0, -2); $flag=1; }
	}
	if ($n>2 and $flag==0) {
		if ($m2>1 and $token=~m/ic$/) { $token=substr($token, 0, -2); $signature=substr($signature, 0, -2); $flag=1; }
	}
	if ($n>4 and $flag==0) {
		if ($m4>1 and $token=~m/able$/) { $token=substr($token, 0, -4); $signature=substr($signature, 0, -4); $flag=1; }
	}
	if ($n>4 and $flag==0) {
		if ($m4>1 and $token=~m/ible$/) { $token=substr($token, 0, -4); $signature=substr($signature, 0, -4); $flag=1; }
	}
	if ($n>3 and $flag==0) {
		$m3=get_m($signature, $n-3); if ($m3>1 and $token=~m/ant$/) { $token=substr($token, 0, -3); $signature=substr($signature, 0, -3); $flag=1; }
	}
	if ($n>5 and $flag==0) {
		$m5=get_m($signature, $n-5); if ($m5>1 and $token=~m/ement$/) { $token=substr($token, 0, -5); $signature=substr($signature, 0, -5); $flag=1; }
	}
	if ($n>4 and $flag==0) {
		if ($m4>1) { $c2=substr($token, length($token)-4, -3); }
		if ($m4>1 and $token=~m/ment$/ and $c2 ne 'e') { $token=substr($token, 0, -4); $signature=substr($signature, 0, -4); $flag=1; }
	}
	if ($n>3 and $flag==0) {
		if ($m3>1) { $c1=substr($token, length($token)-4, -3); $c2=substr($token, length($token)-5, -4); }
		if ($m3>1 and $token=~m/ent$/ and $c1 ne 'm' and !($c2 eq 'e' and $c1 eq 'm')) { $token=substr($token, 0, -3); $signature=substr($signature, 0, -3); $flag=1; }
	}
	if ($n>3 and $flag==0) {
		if ($m3>1) { $c1=substr($token, length($token)-4, -3); }
		if ($m3>1 and ($c1 eq 's' or $c1 eq 't') and $token=~m/ion$/) { $token=substr($token, 0, -3); $signature=substr($signature, 0, -3); $flag=1; }
	}
	if ($n>2 and $flag==0) {
		if ($m2>1 and $token=~m/ou$/) { $token=substr($token, 0, -2); $signature=substr($signature, 0, -2); $flag=1; }
	}
	if ($n>3 and $flag==0) {
		if ($m3>1 and $token=~m/ism$/) { $token=substr($token, 0, -3); $signature=substr($signature, 0, -3); $flag=1; }
	}
	if ($n>3 and $flag==0) {
		if ($m3>1 and $token=~m/ate$/) { $token=substr($token, 0, -3); $signature=substr($signature, 0, -3); $flag=1; }
	}
	if ($n>3 and $flag==0) {
		if ($m3>1 and $token=~m/iti$/) { $token=substr($token, 0, -3); $signature=substr($signature, 0, -3); $flag=1; }
	}
	if ($n>3 and $flag==0) {
		if ($m3>1 and $token=~m/ous$/) { $token=substr($token, 0, -3); $signature=substr($signature, 0, -3); $flag=1; }
	}
	if ($n>3 and $flag==0) {
		if ($m3>1 and $token=~m/ive$/) { $token=substr($token, 0, -3); $signature=substr($signature, 0, -3); $flag=1; }
	}
	if ($n>3 and $flag==0) {
		if ($m3>1 and $token=~m/ize$/) { $token=substr($token, 0, -3); $signature=substr($signature, 0, -3); $flag=1; }
	}
	if ($dsp==1) { print "After step 4: $token\n"; }

	#Step 5a
	$n=length($token); 
	$flag=0;
	if ($n>1) {
		$m1=get_m($signature, $n-1); if ($m1>1 and $token=~m/e$/) { $token=substr($token, 0, -1); $signature=substr($signature, 0, -1); $flag=1; }
	}
	if ($n>1 and $flag==0) {
		if ($m1==1) { $c=substr($signature, length($signature)-4, -1); $c1=substr($token, length($token)-2, -1); $c2=substr($token, length($token)-1); }
		if ($m1==1 and ($n<=3 or !(($c eq 'cvc' and $c1 ne 'w' and $c1 ne 'x' and $c1 ne 'y'))) and $c2 eq 'e') { $token=substr($token, 0, -1); $signature=substr($signature, 0, -1); $flag=1; }
	}
	if ($dsp==1) { print "After step 5a: $token\n"; }

	#Step 5b
	$n=length($token); 
	$flag=0;
	if ($n>1) {
		if ($m1>1) { $c1=substr($token, length($token)-2, -1); $c2=substr($token, length($token)-1); }
		$m1=get_m($signature, $n); if ($m1>1 and $c1 eq 'l' and $c2 eq 'l') { $token=substr($token, 0, -1); $signature=substr($signature, 0, -1); $flag=1; }
	}
	if ($dsp==1) { print "After step 5b: $token\n"; }

	return $token;
}
1;

