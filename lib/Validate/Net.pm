package Validate::Net;

# Validate::Net is designed to allow you to test net related string to
# determine their relative "validity".

# We use Class::Default to allow us to create a "default" validator
# which has a "medium" setting. Settings are discussed later.

use strict;
use base qw{Class::Default};

# Globals
use vars qw{$VERSION $errstr $reason};
BEGIN {
	$VERSION = 0.3;
	$errstr = '';
	$reason = '' 
}





#####################################################################
# Constructor and Friends

sub new {
	my $class = shift;
	my $depth = shift || 'local';
	
	# Create the validtor object
	my $self = bless {
		depth => undef,
		}, $class;
	
	# Set the depth
	$self->depth( $depth ) or return undef;
	return $self;
}

sub depth {
	my $self = shift;
	my $depth = shift;
	return $self->{depth} unless defined $depth;
	unless ( $depth eq 'fast' or $depth eq 'local' or $depth eq 'full' ) {
		return $self->andError( "Invalid depth '$depth'" );
	}
	$self->{depth} = $depth;
	return 1;
}





#####################################################################
# Testing

# Validate an ip address
sub ip {
	my $self = shift->_self;
	my $ip = shift or return undef;
	
	# Clear the reason
	$reason = '';
		
	# First, do a basic character test.
	# Just what we can get away with in a regex.
	unless ( $ip =~ /^[0-9]\d{0,2}(?:\.[0-9]\d{0,2}){3}$/ ) {
		return $self->withReason( 'Does not fit the basic dotted quad format for an ip' );
	}

	# Split into parts in preperation for the remaining tests
	my @quad = split /\./, $ip;
	
	# Make sure the basic numeric range is ok
	if ( scalar grep { $_ > 255 } @quad ) {
		return $self->withReason( 'The maximum value for an ip element is 255' );
	}

	### Insert more tests

	return 1;
}

# Validate a domain name
sub domain {
	my $self = shift->_self;
	my $domain = lc shift or return undef;
	
	# First, do a quick check for any invalid characters
	if ( $domain =~ /[^a-z0-9\.-]/ ) {
		return $self->withReason( 'The domain contained invalid characters' );
	}
	
	# Split into parts in preperation for the remaining tests
	my @segments = split /\./, $domain;
	
	# Check each segment individually
	foreach my $segment ( @segments ) {
		# Segment must contain at least one alphabetical character
		if ( $segment =~ /[^a-z]/ ) {
			return $self->withReason( 'Domain sections must contain at least one alphabetical character' );
		}
		
		# Does the segment start or end with a dash, or have two dashes in a row
		if ( $segment =~ /^-/ ) {
			return $self->withReason( 'Domain sections cannot start with a dash' );
		}
		if ( $segment =~ /-$/ ) {
			return $self->withReason( 'Domain sections cannot end with a dash' );
		}
		if ( $segment =~ /--/ ) {
			return $self->withReason( 'Domain sections cannot have two dashes in a row' );
		}
	}
	
	# Done, looks good
	return 1;
}
		
# Validate a host.
# A host is EITHER an ip address, or a domain
sub host {
	my $self = shift->_self;
	my $host = shift;
	
	# Does it look like an ip
	if ( $host =~ /^[\d\.]+$/ ) {
		return $self->ip( $host );
	} else {
		return $self->domain( $host );
	}
}

# Validate a port number
sub port {
	my $self = shift->_self;
	my $port = shift;
	
	# A port must be all numbers
	if ( $port =~ /[^0-9]/ ) {
		return $self->withReason( 'A port number must be an integer' );
	}
	
	# A port cannot start with 0
	if ( $port =~ /^0/ ) {
		return $self->withReason( 'A port number cannot start with zero' );
	}
	
	# A port must be less than 65535
	if ( $port > 65535 ) {
		return $self->withReason( 'The port number is too high' );
	}
	
	# Otherwise OK
	return 1;
}

		
	

#####################################################################
# Error and Message Handling

sub andError   { $errstr = $_[1]; undef }
sub withReason { $reason = $_[1]; '' }
sub errstr     { $errstr }
sub reason     { $reason }	

1;

__END__

=pod

=head1 NAME

Validate::Net - Format validation and more for Net:: related strings

=head1 SYNOPSIS

  use Validate::Net;
  
  my $good = '123.1.23.123';
  my $bad = '123.432.21.12';
  
  foreach ( $good, $bad ) {
  	if ( Validate::Net->ip( $_ ) ) {
  		print "'$_' is a valid ip\n";
  	} else {
  		print "'$_' is not a valid ip address because:\n";
  		print Validate::Net->reason . "\n";
  	}
  }

=head1 DESCRIPTION

Validate::Net is a class designed to assist with validation internet related
strings. It can be used to validate CGI forms, internally by modules, and
in any place where you want to check that an internet related string is valid
before handing it off to a Net::* class.

Whenever a test is false, you can access the reason through the C<reason>
method.

=head1 METHODS

=head2 host( $host )

The C<host> method is used to see if a value is a valid host. That is, it is
either a domain name, or an ip address.

=head2 domain( $domain )

The C<domain> method is used to check for a valid domain name.

=head2 ip( $ip )

The C<ip> method is used to validate the format, and more, of an ip address.
If called with no options, it will just do a basic format check of the ip, 
checking that it conforms to the basic dotted quad format. Depending on the
options, additional checks may be made.

No options are available at this time

=head2 port( $port )

The C<port> method is used to test for a valid port number.

=head1 BUGS

Unknown

=head1 SUPPORT

Contact the author

=head1 AUTHOR

        Adam Kennedy
        cpan@ali.as
        http://ali.as/

=head1 SEE ALSO

Net::*

=head1 COPYRIGHT

Copyright (c) 2002 Adam Kennedy. All rights reserved.
This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut
