package Enbld::Command::Deploy;

use 5.012;
use warnings;

use parent qw/Enbld::Command/;

use Try::Lite;

require Enbld::Feature;
require Enbld::Home;
require Enbld::Logger;
require Enbld::App::Configuration;
require Enbld::Target;
require Enbld::Deployed;

sub do {
    my $self = shift;

    my $deploy_path = shift @{ $self->{argv} };

    unless ( $deploy_path ) {
        die( "ERROR:'deploy' command requires directory path argument.\n" );
    }

    Enbld::Feature->set_deploy_mode( $deploy_path );
    Enbld::Home->initialize;
    Enbld::Home->create_build_directory;
    Enbld::Logger->rotate( Enbld::Home->log );

    Enbld::App::Configuration->read_file;

    foreach my $name ( keys %{ Enbld::App::Configuration->config } ) {
        my $config = Enbld::App::Configuration->search_config( $name );

        next unless $config->enabled;

        my $target = Enbld::Target->new( $name, $config );
        my $condition = {
            $name   =>  $config->condition( $config->enabled ),
        };

        my $installed = try {
            return $target->deploy_declared( $condition );
        } ( 'Enbld::Error' => sub {
            Enbld::Message->alert( $@ );
            say "Please check build logile:" . Enbld::Logger->logfile;

            return;
            }
          );

        # installed
        if ( $installed ) {
            Enbld::Deployed->add( $installed );
        }
    }        
}

1;
