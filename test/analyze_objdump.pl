#!/usr/bin/perl
use Data::Dumper;
my $file = "hello.o";
open(OBJ, "objdump -Dslx $file|") or die;
my $function;
my %struc;
while (<OBJ>)
{
 $function = $1 if ($_ =~ /(\w+)\(\):$/);
 if($_ =~ /.*:\s+R_386_PC32\s+(\w+)/)
 {
  my $fcall = $1;
  $struc{file}{$function}{$fcall}++;
 }
}
close (OBJ);
print Dumper %struc;

