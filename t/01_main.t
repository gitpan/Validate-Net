#!/usr/bin/perl

# Formal testing for Validate::Net

# Do all the tests on ourself, since we know we will be loaded.

use strict;
use File::Spec::Functions qw{:ALL};
use lib catdir( updir(), updir(), 'modules' ), # Development testing
        catdir( updir(), 'lib' );              # Installation testing
use UNIVERSAL 'isa';
use Test::More tests => 35;

# Check their perl version
BEGIN {
	$| = 1;
	ok( $] >= 5.005, "Your perl is new enough" );
}





# Does the module load
use_ok( 'Validate::Net' );





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
