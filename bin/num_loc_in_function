#!/usr/bin/perl
use File::Find;
#use Cwd;
use strict;
use warnings;
use Data::Dumper;

my $dir = ".";
my $pattern ="\\.[ch|cpp]\$";

find (\&process, $dir);

sub process
{
 return if not /$pattern/;
# print $File::Find::name."\n";
 scan_file ($_); #$File::Find::name);
}

my %h_loc;
my %h_loc_in_function;
sub scan_file 
{
 my $file = $_[0];
 open (FILE, "< $file") or die;
 my $loc = 0;
 my $loc_in_function = 0;
 my $n_function = 0;
 while (<FILE>)
 {
	 $loc++;
	 my $n_function_open = scalar (split /{/, $_)-1;
	 my $n_function_close = scalar (split /}/, $_)-1;
	 $n_function += $n_function_open;
	 $n_function -= $n_function_close;
	 if ($n_function == 0)
	 {
		 $h_loc_in_function{$loc_in_function}++;
		 $loc_in_function = 0;
	 }
	 else
	 {
		 $loc_in_function++;
	 }
#	 printf " %d %d %d \n", $n_function_open, $n_function_close, $n_function;
 }
 $h_loc{$loc}++;
 close (FILE);
}

#print Dumper %h_loc;

open (H_LOC, ">h_loc.txt") or die;
#foreach (sort {$h_loc{$b} <=> $h_loc{$a}} keys %h_loc)
foreach (sort {$b <=> $a} keys %h_loc)
{
 print H_LOC $_." ".$h_loc{$_}."\n";
}
close (H_LOC);

open (H_LOC_IN_FUNCTION, ">h_loc_in_function.txt") or die;
foreach (sort {$b <=> $a} keys %h_loc_in_function)
{
 print H_LOC_IN_FUNCTION $_." ".$h_loc_in_function{$_}."\n";
}
close (H_LOC_IN_FUNCTION);
