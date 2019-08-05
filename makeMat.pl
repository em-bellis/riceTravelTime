#!/usr/bin/perl

#written by E. S. Bellis 12.30.2018
#use this script to create a matrix of rice accessions using pairwise least cost paths distances that were calculated in gdistance for 431 locations rounded to nearest 0.1 degree

my $riceFile = $ARGV[0];
my $distanceFile = $ARGV[1];

#store for each rice accession its lat and lon rounded to nearest 0.1 degree
open(IN, $riceFile);
my %riceLat;
my %riceLon;

#$header = <IN>;
while($line = <IN>) {
	chomp($line);
	@lineParts = split(/\s+/, $line);
	$riceLat{$lineParts[0]} = sprintf("%.1f", $lineParts[1]);
	$riceLon{$lineParts[0]} = sprintf("%.1f", $lineParts[2]);
}
close(IN);

#print a row of column names
foreach my $label (sort(keys %riceLat)) {
	print "\t".$label;
}
print "\n";

#get for each pair the distance
foreach my $label (sort(keys %riceLat)) {
	print $label;
	DISTANCE: foreach my $label2 (sort(keys %riceLat)) {
		open(IN2, $distanceFile);
		while($line = <IN2>) {
			chomp($line);
			@lineParts = split(/\s+/, $line);
			if ($lineParts[1] == $riceLat{$label2} && $lineParts[2] == $riceLon{$label2} && $lineParts[4] == $riceLat{$label} && $lineParts[5]==$riceLon{$label}) {
				print "\t".$lineParts[6];
				close(IN2);
				next DISTANCE;
			} elsif ($lineParts[1] == $riceLat{$label} && $lineParts[2] == $riceLon{$label} && $lineParts[4]== $riceLat{$label2} && $lineParts[5]==$riceLon{$label2}) {
				print "\t".$lineParts[6];
				close(IN2);
				next DISTANCE;
			}
		}
	}
	print "\n";
}
