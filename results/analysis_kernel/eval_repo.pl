#!/usr/bin/perl
# try to check for commits in repo...
use Data::Dumper;
use Storable qw(nstore);
use Storable;

sub _eval ()
{
	open (GIT, "git log --stat |") or die;
	my %d;
	while (<GIT>)
	{
		if ($_ =~ /([\w\/\.]+)\s+\|\s+(\d+) .*/)
		{
			my ($file, $lines) = ($1, $2);
			$d{$file}{$lines}++;
		}
	}
	nstore(\%d, "repo.bin");
}

my %d = %{retrieve ("repo.bin")};

# count total changed lines per file
my %f;
for my $file (keys %d)
{
	for my $c (keys %{$d{$file}})
	{
		$f{$file}+=$c;
	}
}
for my $file (keys %f)
{
	print "$file ".$f{$file}."\n";
}
