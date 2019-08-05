#!/usr/bin/perl

#written by E. S. Bellis 12.30.2018
####use this script to format a matrix of pairwise distances for rice accessions

my $riceFile = $ARGV[0];  #this file has columns describing id, latitude, and longitude for all rice accessions to include in matrix
my $distanceFile = $ARGV[1]; #this file has columns with each row describing a pair of accessions with the following columns: ID_A,Lat_A, Lon_A, ID_B, Lat_B, Lon_B, Distance. ID_A or ID_B do not need to match accession name; they refer to a unique coordinate pair since many accessions have the same location

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
