#!/usr/bin/perl
# input: compiled .o files
# output: the .bin (.nw / .func_defs) files

use warnings;
use Data::Dumper;
use Storable qw(nstore);
use Term::ProgressBar 2.00;

my $dir = "./drivers/media/dvb/frontends/";
$dir = "./";
my $outfile = "network";

my @files = split ("\n", `find $dir -name "*.o"`);
my %nm;

my $progress = Term::ProgressBar->new($#files);
my $i;
foreach $file (@files)
{
 $progress->update($i++);
 $progress->message($file);
 open(NM, "nm -P $file|") or die;
 while (<NM>)
 {
  $_ =~ /^([\._\w]*) (\w)/;
  my $function = $1;
  my $type = $2;
  $function or die;
  $type or die;
  $nm{$file}{$function} = $type;
 }
 close (NM);
}
#print Dumper %nm;
nstore(\%nm, "$outfile.nm.bin"); 

my %nw;
my %func_defs;
$i = 0;
my $file_idx, $func_idx;
foreach my $file (keys %nm)
{
 $progress->update($i++);
 $progress->message($file);
 $nw{$file}{idx} = $file_idx++;
 foreach my $function (keys %{$nm{$file}}) 
 {
$nw{$file}{in}{$function} = $func_idx++  if ($nm{$file}{$function} =~ /[tTu]/);
$nw{$file}{out}{$function} = $func_idx++ if ($nm{$file}{$function} =~ /[U]/);
$func_defs{$function} = $file if ($nm{$file}{$function} =~ /[tTu]/);
 }
}
print Dumper %nw;
print Dumper %func_defs;
nstore(\%nw, "$outfile.nw.bin"); 
nstore(\%func_defs, "$outfile.func_defs.bin"); 
