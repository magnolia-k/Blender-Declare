package Enbld::Condition;

use 5.012;
use warnings;

sub new {
    my $class = shift;

    my $self = {
        version     =>  'latest',
        make_test   =>  undef,
        modules     =>  undef,
        arguments   =>  undef,
        annotation  =>  undef,
        @_,
    };

    bless $self, $class;

    return $self;
}

sub name {
    return $_[0]->{name};
}

sub version {
    return $_[0]->{version};
}

sub make_test {
    return $_[0]->{make_test};
}

sub modules {
    return $_[0]->{modules};
}

sub arguments {
    return $_[0]->{arguments};
}

sub annotation {
    return $_[0]->{annotation};
}

sub serialize {
    my $self = shift;

    my %serialized;
    foreach my $key ( sort keys %{ $self } ) {
        next if ( ! $self->{$key} );

        $serialized{$key} = $self->{$key};
    }

    return \%serialized;
}

sub is_equal_to {
    my ( $self, $condition ) = @_;

    return unless ( _is_equal( $self->{version},      $condition->version    ));
    return unless ( _is_equal( $self->{make_test},    $condition->make_test  ));
    return unless ( _is_equal( $self->{arguments},    $condition->arguments  ));
    return unless ( _is_equal( $self->{annotation},   $condition->annotation ));
    return unless ( _is_equal_hash( $self->{modules}, $condition->modules    ));

    return $self; 
}

sub _is_equal {
    my ( $val1, $val2 ) = @_;

    return 1 if ( ( ! defined $val1 ) && ( ! defined $val2 ) );
    return 1 if ( ( defined $val1 ) && ( defined $val2 ) && $val1 eq $val2 );

    return;
}

sub _is_equal_hash {
    my ( $val1, $val2 ) = @_;

    return 1 if ( ( ! defined $val1 ) && ( ! defined $val2 ) );

    my $str1 = join( '', keys %{ $val1 } ) if ( defined $val1 );
    my $str2 = join( '', keys %{ $val2 } ) if ( defined $val2 );

    return 1 if ( ( defined $val1 ) && ( defined $val2 ) && $str1 eq $str2 );

    return;
}

1;
