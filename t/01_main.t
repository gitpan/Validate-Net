#!/usr/bin/perl

# Formal testing for Class::Inspector

# Do all the tests on ourself, since we know we will be loaded.

use strict;
use lib '../../../modules'; # For development testing
use lib '../lib'; # For installation testing
use UNIVERSAL 'isa';
use Test::More tests => 35;
use Class::Inspector;

# Set up any needed globals
use vars qw{$loaded};
BEGIN {
	$loaded = 0;
	$| = 1;
}




# Check their perl version
BEGIN {
	ok( $] >= 5.005, "Your perl is new enough" );
}





# Does the module load
END { ok( 0, 'Validate::Net loads' ) unless $loaded; }
use Validate::Net;
$loaded = 1;
ok( 1, 'Validate::Net loads' );





# Create a bunch of basic "good" and "bad" ips
my @good = qw{
	1.2.3.4
	0.0.0.0
	};
my @bad = qw{1.2.3};

# Check the good and bad ips
foreach ( @good ) {
	ok( Validate::Net->ip( $_ ), "'$_' passes ->ip correctly" );
	ok( Validate::Net->host( $_ ), "'$_' passes ->host correctly" );
}
foreach ( @bad ) {
	ok( ! Validate::Net->ip( $_ ), "'$_' fails ->ip correctly" );
}




# Create a bunch of basic "good" and "bad" domain and host names
@good = qw{
	foo
	bar
	foo-bar
	32146
	black.342.hole
	dot.at.end.
	};
@bad = qw{
	1st
	-blah
	blah-
	blah--blah
	reallyreallyreallyreallyreallyreallyreallyreallyreallyreallyreallyreallylong
	.dot.at.start
	this.is.1st.also.bad
	blah.blah-.blah
	};

# Check the good and bad domains
foreach ( @good ) {
	ok( Validate::Net->domain( $_ ), "'$_' passes ->domain correctly" );
	ok( Validate::Net->host( $_ ), "'$_' passes ->host correctly" );
}
foreach ( @bad ) {
	ok( ! Validate::Net->domain( $_ ), "'$_' fails ->domain correctly" );
	ok( ! Validate::Net->host( $_ ), "'$_' fails ->host correctly" );
}
