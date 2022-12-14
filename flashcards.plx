#!/usr/bin/env perl
use strict;
use warnings;

my $input;
my $delimeter = ",";
my %cards;
my $line;
my @fields;
my $field_count; #keep track of how many fields should be in each row
my $term_field;  #keep track of which column is the term
my $def_field;   #keep track of which column is the definition

sub gethelp() {
	print "Usage: $0 [OPTION]... [FILE]\n";
	print "Run through flashcards from CSV file\n\n";
	print " -d, --delimeter DELIMETER   Set CSV delimeter to DELIMETER\n";
	print " -h, --help                  Print this help message\n";
}

# Check for argument
if($#ARGV < 0) {
	die "Error: missing argument";
}


# Read flags
while($#ARGV >= 0) {
	if($ARGV[0] =~ /-h|--help/) {
		gethelp();
		exit;
	}
	if($ARGV[0] =~ /-d|--delimeter/) {
		$delimeter = $ARGV[1] or die "Error: flag missing argument";
		shift;
		shift;
		next;
	}
	else {
		$input = $ARGV[0] or die "Error: missing filename argument";
		last;
	}
}

# Attempt to open
open(my $fh, "<", "$input") or die "Error: could not open \"$input\"";

# Read first line to determine which column is a function, and which is a definition
$line = <$fh>;
chomp $line;
@fields = split($delimeter, $line);
$field_count = $#fields;
for(my $i = 0; $i <= $field_count; ++$i) {
	if($fields[$i] eq "term") {
		$term_field = $i;
	}
	elsif($fields[$i] eq "definition") {
		$def_field = $i;
	}
}

#print "$field_count\n";
#print "$term_field\n";
#print "$def_field\n";

# Check that delimeter produces valid table
if($field_count < 1) {
	close($fh);
	die "Error: invalid table (no delimeter)";
}

# Get terms and definitions and close the filehandle
while($line = <$fh>) {
	chomp $line;
	@fields = split($delimeter, $line);
	$cards{$fields[$term_field]} = $fields[$def_field];
}
close($fh);

# Go through each card (automatically shuffled!)
while(scalar %cards > 0) {
	print scalar %cards . " cards remaining\n";
	readline(STDIN);
	foreach my $k (keys %cards) {
		print "$k\n";
		readline(STDIN);
		print "$cards{$k}\n";

		# Check if card should be placed back in deck or discarded
		print "Discard? [Y/n] ";
		$line = readline(STDIN);
		if(!($line =~ /[nN].*/)) {
			delete $cards{$k};
		}
		print "\n";
	}
}
