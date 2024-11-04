use 5.10.0;
use strict;

my %idlist;
while (<>){
	chomp;
	next if /^$/;
	my ($id, $version, $letters) = /^([* 0-9]*)\t([0-5-]*)\t([*A-Ea-e \t]*)\s*$/ or
		die "Unparsed line $_";
	$id =~ s/.*[*].*/0/;
	unless (defined $idlist{$id}){
		$idlist{$id} = 0;
		$version =~ s/[^0-5-]*(-?[0-5]).*/$1/;
		$letters =~ tr/a-e/A-E/;
		$letters =~ s/\s//g;
		$letters =~ s/./$&\t/g;
		$letters =~ s/\s*$//;
		say "#$id\t$version\t$letters"
	} else {
		say STDERR "repeat ID $id";
	}
}

