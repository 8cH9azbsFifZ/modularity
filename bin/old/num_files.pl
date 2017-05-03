#!/usr/bin/perl
# analyze the number of files in a directory
use Data::Dumper;
my @dirs = map {chomp; $_} `find . -type d`;
#print Dumper @dirs;
my %h_dir;
foreach my $dir (@dirs)
{
 my @files = <$dir/*>;
 my $count = @files;
 $h_dir{$dir} = $count;
}

open (H_DIR, ">h_dir.txt") or die;
foreach (sort {$b <=> $a} keys %h_dir)
{
 print H_DIR $_." ".$h_dir{$_}."\n";
}
close (H_DIR);
