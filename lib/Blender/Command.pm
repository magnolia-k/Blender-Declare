package Blender::Command;

use 5.012;
use warnings;

require Blender::Require;
require Blender::Message;
require Blender::Home;
require Blender::Logger;
require Blender::ConfigCollector;

sub new {
    my $class = shift;

    my $self = {
        cmd         =>  undef,
        argv        =>  undef,
        @_,
    };

    my $module = 'Blender::Command::' . ucfirst( $self->{cmd} );

    eval { Blender::Require->try_require( $module ) };

    if ( $@ ) {
        die 'ERROR:Unknown command:' . $self->{cmd} . "\n";
    }

    return bless $self, $module;
}

sub setup {
    Blender::Home->initialize;
    Blender::Home->create_build_directory;
    Blender::Logger->rotate( Blender::Home->log );

    Blender::ConfigCollector->read_configuration_file;
}

sub teardown {
    Blender::ConfigCollector->write_configuration_file;
}

sub validate_target_name {
    my ( $self, $target_name ) = @_;

    if ( ! $target_name ) {
        die "ERROR:'$self->{cmd}' command requires target's name argument.\n";
    }

    if ( $target_name =~ /[^a-z0-9]/ ) {
        die "ERROR:target's name '$target_name' is invalid.\n";
    }

    return $target_name;
}

1;