package Enbld::Target::Attribute::CommandTest;

use strict;
use warnings;

use parent qw/Enbld::Target::AttributeExtension::Command/;

sub initialize {
    my ( $self, $param ) = @_;

    if ( ! defined $param ) {
        $self->{value} = 'make check';
        $self->{is_evaluated}++;

        return $self;
    }

    if ( $param ) {
        $self->SUPER::initialize( $param );
        return $self;
    }

    # empty string is valid
    $self->{is_evaluated}++;
}

sub validate {
    my ( $self, $string ) = @_;

    # nothing check now.

    return $string;
}

1;
