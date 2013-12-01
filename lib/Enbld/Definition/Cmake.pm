package Enbld::Definition::Cmake;

use 5.012;
use warnings;

use parent qw/Enbld::Definition/;

sub initialize {
    my $self = shift;

    $self->SUPER::initialize;

    $self->{defined}{ArchiveName}       =   'cmake';
    $self->{defined}{WebSite}           =   'http://www.cmake.org';
    $self->{defined}{VersionForm}       =   '\d\.\d\.\d{1,2}(\.\d)?';
    $self->{defined}{DownloadSite}      =   'http://www.cmake.org/files/';

    $self->{defined}{VersionList}       =   \&set_versionlist;
    $self->{defined}{URL}               =   \&set_url;

    $self->{defined}{CommandConfigure}  =   './configure';
    $self->{defined}{CommandMake}       =   'make';
    $self->{defined}{CommandTest}       =   'make test';
    $self->{defined}{CommandInstall}    =   'make install';

    return $self;
}

sub set_versionlist {
    my $attributes = shift;

    require Enbld::HTTP;
    my $first_html = Enbld::HTTP->get_html( $attributes->IndexSite );

    my $first_list = $first_html->parse_version(
            quotemeta( '<a href="v') . '\d\.\d/' . quotemeta( '">' ),
            'v\d\.\d'
            );

    my @versionlist;
    for my $ver ( @{ $first_list } ) {
        my $html = Enbld::HTTP->get_html( $attributes->IndexSite . $ver );
        my $list = $html->parse_version(
                $attributes->IndexParserForm,
                $attributes->VersionForm,
                );

        for my $version ( @{ $list } ) {
            push @versionlist, $version;
        }
    }

    return \@versionlist;
}

sub set_url {
    my $attributes = shift;

    my $ver = $attributes->Version;

    my $major;
    if ( $ver =~ /^(\d\.\d)\.\d{1,2}(\.\d)?.*$/ ) {
        $major = $1;
    }

    my $filename = $attributes->Filename;
    my $url = $attributes->DownloadSite . 'v' . $major . '/' . $filename;

    return $url;
}

1;
