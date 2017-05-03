#!/usr/bin/perl
use warnings;
use Data::Dumper;
use Storable;
#use Term::ProgressBar 2.00;

my $infile = "network";
my $outfile = "network";

#my %nm = %{retrieve ("$infile.nm.bin")};
my %nw = %{retrieve ("$infile.nw.bin")}; 
my %func_defs = %{retrieve ("$infile.func_defs.bin")}; 
$func_defs{"undefined"} = "undefined";

print "#files: ",int(keys %nw),"\n";
open (FILE1, ">$outfile.files.csv") or die;
open (FILE2, ">$outfile.links.csv") or die;
open (FILE3, ">$outfile.numlinks.txt") or die;
open (FILE4, ">$outfile.histolinks.in.txt") or die;
open (FILE5, ">$outfile.histolinks.out.txt") or die;
print FILE1 "Id;Label\n";
print FILE2 "Source;Target;Label;Weight\n";
print FILE3 "#filename inlinks outlinks\n";
print FILE4 "#numlinks numfiles_with_numlinks\n";
print FILE5 "#numlinks numfiles_with_numlinks\n";
my %h_link;
my $i;
foreach my $file (keys %nw)
{
 print "\r",$i++," of ",int(keys %nw);
 my $label = `basename $file`;
 chomp($label);
 print FILE1 $nw{$file}{idx},";$label\n";
 my $source = $nw{$file}{idx};
 foreach my $function (keys %{$nw{$file}{out}})
 {
  if ($func_defs{$function})
  {
   my $target_name = $func_defs{$function} or "undefined";
   my $target = $nw{$target_name}{idx};
   my $label = $function;
   my $weight = 1;
	print FILE2 "$source;$target;$label;$weight\n";
  }
 }
 my $inlinks  = int(keys %{$nw{$file}{in}});
 my $outlinks = int(keys %{$nw{$file}{out}});
 print FILE3 "$file $inlinks $outlinks\n";
 $h_link{in}{$inlinks}++;
 $h_link{out}{$outlinks}++;
}
print FILE4 $h_link{in}{$_}," $_\n" foreach (keys %{$h_link{in}});
print FILE5 $h_link{out}{$_}," $_\n" foreach (keys %{$h_link{out}});
close (FILE1);
close (FILE2);
close (FILE3);
close (FILE4);
close (FILE5);
