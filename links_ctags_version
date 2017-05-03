#!/usr/bin/perl
use File::Find;
#use Cwd;
#use strict;
use warnings;
use Data::Dumper;
use Storable;
#use Term::ProgressBar 2.00;

#ramdisk
## diskutil erasevolume HFS+ "ramdisk" `hdiutil attach -nomount ram://2000000` 

#perl -d:NYTProf ./links
#nytprofhtml nytprof.out 
#

my $dir = "linux_kernel/linux-3.3-rc3//virt/kvm/";
#my $dir = "linux_kernel/linux-3.3-rc3//block/";
#my $dir = "linux_kernel/linux-3.3-rc3//";
#my $dir = "/Volumes/ramdisk/linux-3.3-rc3//virt/kvm/";
my $dir = "linux_kernel/linux-3.3-rc3/drivers/net/";

print "Run ctags\n";
`./ctags/bin/ctags --c-kinds=-deglmnpstuvx -R $dir/`;

print "Analyze tags\n";
my %struc;
open (TAGS, "< tags") or die;
while (<TAGS>)
{
 next if $_ =~ /^!/;
 my @d = split (/\s+/, $_);
 my ($function, $filename) = ($d[0], $d[1]);
 next if $filename !~ /\.c$/;
 #print $function," ",$filename,"\n";
 $struc{$filename}{$function}{existing} = 1;
}
close (TAGS);
#print Dumper %struc;

foreach my $file (keys %struc)
{
 print "Scan functions in file ",$file,"\n";
 foreach my $function (keys %{$struc{$file}})
 {
# print $file," ",$function,"\n";
  open (GREP, "grep -R $function $dir/* |") or die;
  while (<GREP>)
  {
	my @d = split (/:/, $_);
	my $ffile = $d[0];
   next if $ffile !~ /\.c$/;
#	print "string: ",$_,"\n";
#	print $ffile,"\n";
	$struc{$file}{$function}{$ffile}++;
  }
  close (GREP);
 }
}
#print Dumper %struc;
#
store \%struc, "struc.bin" or die;

# how many calls has a function?
my %func_calls;
foreach my $file (keys %struc)
{
 foreach my $function (keys %{$struc{$file}})
 {
  $func_calls{$function} -= 1; # 1 occurance for definition 
  foreach my $ffile (keys %{$struc{$file}{$function}})
  {
	next if $ffile =~ /existing/;
	$func_calls{$function} += $struc{$file}{$function}{$ffile};
  }
 }
}
#create sorted list 
print $_," ",$func_calls{$_},"\n" foreach (sort {$func_calls{$b} <=> $func_calls{$a}} keys %func_calls);
