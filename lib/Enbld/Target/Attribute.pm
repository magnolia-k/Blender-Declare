package Enbld::Target::Attribute;

use strict;
use warnings;

use Carp;

use Module::Load;
use Module::Load::Conditional qw/can_load/;

sub new {
    my ( $class, $name, $param ) = @_;

    if ( ! $name ) {
        require Enbld::Exception;
        croak( Enbld::Exception->new( "'$class' requires name" ) );
    }

    my $module = "Enbld::Target::Attribute::$name";

    if ( can_load( modules => { $module => undef } ) ) {
        load $module;

        my $self = {
            attributes      =>  undef,
            value           =>  undef,
            callback        =>  undef,
            is_evaluated    =>  undef,
        };

        bless $self, $module;

        $self->initialize( $param );

        return $self;
    }

    require Enbld::Exception;
    croak( Enbld::Exception->new( "Attribute '$name' is invalid name" ) );
}


sub initialize {
    my ( $self, $param ) = @_;

    if ( ref( $param ) eq 'CODE' ) {
        $self->{callback} = $param;
        return $self;
    }

    $self->{value} = $param;
    $self->{is_evaluated}++;
    return $self;
}

sub validate {
    my ( $self, $string ) = @_;

    if ( ! $string ) {
        my $type = ref( $self );
        $type =~ s/.*:://;
        require Enbld::Exception;
        croak( Enbld::Exception->new( "Attribute '$type' is empty string" ));
    }

    if ( ref( $string ) ) {
        my $type = ref( $self );
        $type =~ s/.*:://;

        my $err = "Attribute '$type' isn't scalar value";
        require Enbld::Exception;
        croak( Enbld::Exception->new( $err, $string ));
    }

    return $string;
}

sub evaluate {
    my $self = shift;

    return $self->{value} if $self->{is_evaluated};
    
    $self->{value} = $self->{callback}->( $self->{attributes} );
    $self->{is_evaluated}++;

    return $self->{value};
}

sub to_value {
    my $self = shift;

    my $value = $self->evaluate;

    return '' if ( ( ! $value ) && $self->is_omitable );

    $self->validate( $value );

    return $value;
}

sub is_omitable {
    return; # if attribute is not omitable, override this method in sub class.
}

sub link_to_collector {
    my ( $self, $collector ) = @_;

    $self->{attributes} = $collector;
}

1;
