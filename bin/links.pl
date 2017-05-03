#!/usr/bin/perl
use File::Find;
#use strict;
use warnings;
use Data::Dumper;
use Storable qw(nstore);
use Term::ProgressBar 2.00;
use FileHandle;

use Getopt::Std;
my %opts;
getopt('d:o:n', \%opts);
my $dir = $opts{d};
my $outfile = $opts{o};

print "Analyze files\n";
my @files = split ("\n", `find $dir -name "*.o"`);
#my @files = split ("\n", `find $dir -name "pair*eam*.o"`);
my $function;
my %struc;
my $i;
my $node_index;
# alternative:
if ($opts{n})
{
 print "Use nm\n";
 my $progress = Term::ProgressBar->new($#files);
 foreach $file (@files)
 {
  $progress->update($i++);
  $progress->message($file);
  open(NM, "nm -P $file|") or die;
  while (<NM>)
  {
	$_ =~ /(.*) (.) .*/;
	my $function = $1;
	my $symbol = $2;
	if ($symbol =~ /[Tt]/)
	{
	 $struc{def}{$file}{$function}{occ}++;
	 $struc{def}{$file}{$function}{node_index} = $node_index++;
	 $struc{func_file}{$function} = $file;
	}
	if ($symbol =~ /U/)
	{
	 my $fcall = $function; 
	 $function = $file; # nm cannot resolve which functions calls what => define source function as filename
    $struc{links}{$file}{$function}{$fcall}++;
	}
  }
  close (NM);
 }
}
else
{
 print "Use objdump\n";
 my $progress = Term::ProgressBar->new($#files);
 foreach $file (@files)
 {
  $progress->update($i++);
  $progress->message($file);
  open(OBJ, "objdump -Dslx $file|") or die;
  while (<OBJ>)
  {
   if ($_ =~ /(\w+)\(\):$/) 
   # FIXME: check whether ~ in function names matches etc
   # FIXME: check external functions (i.e. lammps atoi) - could be cuz linked as lib?? :>
   {
    $function = $1;
    $struc{def}{$file}{$function}{occ}++; # mark all defined functions
    $struc{def}{$file}{$function}{node_index} = $node_index++;
    $struc{func_file}{$function} = $file;
   }
   if($_ =~ /.*:\s+R_386_PC32\s+(\w+)/)
   {
    my $fcall = $1;
    $struc{links}{$file}{$function}{$fcall}++;
   }
  }
  close (OBJ);
 }
}
# write file
#my $str = Data::Dumper->Dump([ \%struc], [ '$strucref' ]);
#my($out) = new FileHandle ">$outfile.txt";
#print $out $str;
#close $out;
#`gzip $outfile.txt`;
nstore(\%struc, "$outfile.bin");


#print Dumper %struc;

