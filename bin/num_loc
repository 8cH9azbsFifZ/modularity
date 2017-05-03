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
sub scan_file 
{
 my $file = $_[0];
 open (FILE, "< $file") or die;
 my $loc = 0;
 $loc++ while (<FILE>);
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
