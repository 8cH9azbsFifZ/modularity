#!/usr/bin/perl
use File::Find;
#use Cwd;
#use strict;
use Digest::MD5  qw(md5 md5_hex md5_base64);
use warnings;
use Data::Dumper;
use Storable;

my %struc = %{retrieve("struc.bin")};

# how many calls has a function?
my %func_calls;
foreach my $file (keys %struc)
{
 foreach my $function (keys %{$struc{$file}})
 {
  $func_calls{$function} -= 1; # 1 occurance for definition 
  foreach my $ffile (keys %{$struc{$file}{$function}})
  {
	next if $ffile =~ /exists/;
	$func_calls{$function} += $struc{$file}{$function}{$ffile};
  }
 }
}

# total number of function calls
#create sorted list and histrogram
my %func_calls_histo;
open (FILE, ">func_calls.txt") or die;
print FILE "#function_name function_calls\n"; 
foreach (sort {$func_calls{$b} <=> $func_calls{$a}} keys %func_calls)
{
 $func_calls_histo{$func_calls{$_}}++;
 print FILE $_," ",$func_calls{$_},"\n";
}
close (FILE);
open (FILE, ">func_calls_histo.txt") or die;
print FILE "# #function_calls #occurrences_with_x_func_calls\n";
foreach (sort {$a <=> $b} keys %func_calls_histo)
{
 print FILE "$_ $func_calls_histo{$_}\n";
}
close (FILE);

# analyze connections of files
# TODO: connections of functions
# list of connected functions and histogram
my %conn;
foreach my $file (keys %struc)
{
 foreach my $function (keys %{$struc{$file}})
 {
  foreach my $ffile (keys %{$struc{$file}{$function}})
  {
   $conn{$file}{$ffile}++;
  }
 }
}
my %conn_histo;
my $conn_histo_n;
open (FILE, ">conn.txt") or die;
print FILE "# file1 file2 #connecting_function_calls\n";
foreach my $x (keys %conn)
{
 foreach my $y (keys %{$conn{$x}})
 {
  print FILE "$x $y ",$conn{$x}{$y},"\n" ;
  $conn_histo{$conn{$x}{$y}}++;
  $conn_histo_n++;
 }
}
close (FILE);
my $j;
my %id_list;
foreach my $x (keys %conn)
{
 $j++;
 $id_list{$x}=$j;
}
open (FILE, ">conn_nodes.csv") or die;
open (FILE1, ">conn_edges.csv") or die;
my $i;
print FILE "ID; ID_Label; Label; Mod Class;\n";
print FILE1 "Source; Target;\n";
foreach my $x (keys %conn)
{
 $i++;
 print FILE "$i; $x; $x; 0;\n";
 foreach my $y (keys %{$conn{$x}})
 {
#  print FILE1 $id_list{$x},"; ",$id_list{$y},"; \n"; 
print $id_list{$y};
	 #"$x; $y;\n";
 }
}
close (FILE);
close (FILE1);
open (FILE, ">conn_histo.txt") or die;
print FILE "# #connections #occurrences_with_x_connections probability_of_connection\n";
my $conn_avg;
foreach (sort {$a <=> $b} keys %conn_histo)
{
 $conn_avg += $_*$conn_histo{$_};
 print FILE "$_ $conn_histo{$_} ",$conn_histo{$_}/$conn_histo_n,"\n"; 
}
$conn_avg /= $conn_histo_n;
print FILE "#avg connections: $conn_avg\n";
close (FILE);
