#!/usr/bin/perl
use File::Find;
use warnings;
use Data::Dumper;
use Storable;
#use Term::ProgressBar 2.00;
use FileHandle;

use Getopt::Std;
my %opts;
getopt('i:', \%opts);

# read in file
if (1==2)
{
my $infile = $opts{i};
print "Read in file $infile\n";
my %struc;
my($in) = new FileHandle "gunzip --to-stdout $infile|";
local($/) = "";
my($str) = <$in>;
close $in;
print "Create structure\n";
my($strucref);
eval $str;
print "Reference structure\n";
(%struc) = %$strucref;
print "Start analysis\n";
}
my %struc = %{retrieve ("filename")};
print Dumper %struc;

# evaluation options
#$opts{filetree_network} = 1;
$opts{files_network} = 1;
#$opts{directories_network} = 1;
#$opts{functions_network} = 1;

# list defined functions per file
# csv doc: https://gephi.org/users/supported-graph-formats/spreadsheet/
if ($opts{functions_network})
{
open (FILE1, ">func_defs.txt") or die;
open (FILE2, ">func_defs.csv") or die;
print FILE1 "#filename function number_of_definitions node_index\n";
print FILE2 "Id;Label\n";
foreach my $file (keys %{$struc{def}})
{
 foreach my $function (keys %{$struc{def}{$file}})
 {
  print FILE1 "$file $function ",$struc{def}{$file}{$function}{occ}," ",
   $struc{def}{$file}{$function}{node_index},"\n";
  print FILE2 $struc{def}{$file}{$function}{node_index},";$function\n";
 }
}
close (FILE1);
close (FILE2);
open (FILE1, ">func_call_links.txt") or die;
open (FILE2, ">func_call_links.csv") or die;
print FILE1 "#func1 func2 link_via_filename #links func1_idx func2_idx\n";
print FILE2 "Source;Target;Label;Weight\n";
foreach my $file (keys %{$struc{links}})
{
 foreach my $function (keys %{$struc{links}{$file}})
 {
  foreach my $fcall (keys %{$struc{links}{$file}{$function}})
  {
	my $func2_idx = "";
   $func2_idx = $struc{def}{$file}{$fcall}{node_index} if ($struc{def}{$file}{$fcall}{node_index});
   print FILE1 "$function $fcall $file ",$struc{links}{$file}{$function}{$fcall},
	 " ",$struc{def}{$file}{$function}{node_index}," $func2_idx\n";
   if ($struc{def}{$file}{$fcall}{node_index}) #CLEANUP: dirty
	{
	 my $label = `basename $file`;
	 chomp ($label);
	 print FILE2 $struc{def}{$file}{$function}{node_index},";",$struc{def}{$file}{$fcall}{node_index},";$label;",$struc{links}{$file}{$function}{$fcall},"\n";
   }
  }
 }
}
close (FILE1);
close (FILE2);
}

# based on files
if ($opts{files_network})
{
print "Analyze files network\n";
my %file_index;
$i = 0;
open (FILE1, ">file_defs.csv") or die;
print FILE1 "Id;Label\n";
foreach my $file (keys %{$struc{def}})
{
 $file_index{$file} = $i++;
 my $label = `basename $file`; #$file;
 chomp($label);
 print FILE1 $file_index{$file},";$label\n";
}
close (FILE1);
print "Scan neighbors\n";
#my $progress = Term::ProgressBar->new(int ((keys %{$struc{links}})));
open (FILE1, ">file_links.csv") or die;
print FILE1 "Source;Target;Label;Weight\n";
$i = 0;
foreach my $file (keys %{$struc{links}})
{
 my $source = $file_index{$file};
 print "\r$i of ",int ((keys %{$struc{links}}));
# $progress->update($i++);
# $progress->message($file);
 foreach my $function (keys %{$struc{links}{$file}})
 {
  foreach my $fcall (keys %{$struc{links}{$file}{$function}})
  {
	# where is this function defined?
  	# FIXME: multiply defined function names may cause trouble
	my $target;
	if ($struc{def}{$file}{$fcall}{occ})
	{ # self reference
	 $target = $source;
	}
	else
	{
	 if ($struc{func_file}{$fcall}) #function in table?
	 {
	  my $file1 = $struc{func_file}{$fcall};
	  $target = $file_index{$file1};
    }
	 else
	 {
	  $target = "";
	 }
	}
	my $label = $fcall;
	my $weight = $struc{links}{$file}{$function}{$fcall};
	print FILE1 "$source;$target;$label;$weight\n";
  }
 }
}
close(FILE1);
}

# plain file tree
if ($opts{filetree_network})
{
open (FILE1, ">file_tree_links.csv") or die;
open (FILE2, ">file_tree_defs.csv") or die;
print FILE1 "Source;Target;Label;Weight\n";
print FILE2 "Id;Label\n";
my %file_tree_index;
my $index;
foreach my $file (keys %{$struc{links}})
{
 my @l = split ("/", $file); 
 my $n = "";
 for my $i (0..$#l)
 {
  $n = $n . $l[$i];
  $file_tree_index{$n} = $index++;
 }
}
foreach (keys %file_tree_index)
{
 print FILE2 $file_tree_index{$_},";$_\n";
}
foreach my $file (keys %{$struc{links}})
{
 my @l = split ("/", $file); 
 my $n = "";
 for my $i (0..$#l-1)
 {
  $n = $n . $l[$i];
  my $source = $file_tree_index{$n};
  my $target = $file_tree_index{$n . $l[$i+1]};
  my $weight = 1;
  my $label = "none";
  print FILE1 "$source;$target;$label;$weight\n";
 }
}
close (FILE1);
close (FILE2);
}

# based on directories
if ($opts{directories_network})
{
my %directory_index;
$i = 0;
open (FILE1, ">directory_defs.csv") or die;
print FILE1 "Id;Label\n";
foreach my $file (keys %{$struc{def}})
{
 my $label = `dirname $file`; #$file;
 chomp($label);
 $directory_index{$label} = $i++;
 print FILE1 $directory_index{$label},";$label\n";
}
close (FILE1);
open (FILE1, ">directory_links.csv") or die;
print FILE1 "Source;Target;Label;Weight\n";
my %dir_links;
my $j;
my $magic = 100;
#my $progress = Term::ProgressBar->new(int ((keys %{$struc{links}}) / $magic));
foreach my $file (keys %{$struc{links}})
{
# $progress->update(int($j++/$magic));
 my $src_dir = `dirname $file`;
 chomp ($src_dir);
 my $source = $directory_index{$src_dir};
 foreach my $function (keys %{$struc{links}{$file}})
 {
  foreach my $fcall (keys %{$struc{links}{$file}{$function}})
  {
	# where is this function defined?
  	# FIXME: multiply defined function names may cause trouble
	my $target;
	if ($struc{def}{$file}{$fcall}{occ})
	{ # self reference
	 $target = $source;
	}
	else
	{
	 if ($struc{func_file}{$fcall}) #function in table?
	 {
	  my $file1 = $struc{func_file}{$fcall};
	  my $trg_dir = `dirname $file1`;
	  chomp ($trg_dir);
	  $target = $directory_index{$trg_dir};
    }
	 else
	 {
	  $target = "";
	 }
	}
	my $label = $fcall;
	my $weight = $struc{links}{$file}{$function}{$fcall};
 	$dir_links{$source}{$target} += $weight if ($target);
#	print FILE1 "$source;$target;$label;$weight\n";
  }
 }
}
foreach my $source (keys %dir_links)
{
 foreach my $target (keys %{$dir_links{$source}})
 {
  my $weight = $dir_links{$source}{$target};
  print FILE1 "$source;$target;;$weight\n";
 } 
}
close(FILE1);
}


