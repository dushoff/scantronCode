use 5.10.0;
use strict;

my %idlist;
while (<>){
	chomp;
	next if /^$/;
	my ($id, $version, $scores) = /^([* 0-9]*)\t([0-5-]*)\t([*A-E \t]*)\s*$/ or
		die "Unparsed line $_";
	$id =~ s/.*[*].*/0/;
	unless (defined $idlist{$id}){
		$idlist{$id} = 0;
		$version =~ s/[^0-5-]*(-?[0-5]).*/$1/;
		say "#$id\t$version\t$scores"
	} else {
		say STDERR "repeat ID $id";
	}
}

