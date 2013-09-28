#!/usr/bin/perl

use 5.012;
use warnings;

use Test::More;

require Enbld::Target::AttributeCollector;

my $no = Enbld::Target::AttributeCollector->new;
$no->add( 'ArchiveName', 'archive' );
$no->add( 'DistName' );
is( $no->DistName, 'archive', 'no parameter' );

my $empty = Enbld::Target::AttributeCollector->new;
eval { $empty->add( 'DistName', '' ) };
like( $@, qr/ABORT:Attribute 'DistName' isn't defined/, 'empty parameter' );

my $fixed = Enbld::Target::AttributeCollector->new;
$fixed->add( 'DistName', 'archive' );
is( $fixed->DistName, 'archive', 'fixed parameter' );

my $coderef = Enbld::Target::AttributeCollector->new;
$coderef->add( 'DistName', sub { return 'archive' } );
is( $coderef->DistName, 'archive', 'coderef parameter' );

my $space = Enbld::Target::AttributeCollector->new;
$space->add( 'DistName', 'a r c h i v e' );
eval { $space->DistName };
like( $@, qr/ABORT:Attribute 'DistName' includes space character/,
          'including space character' );

my $undef = Enbld::Target::AttributeCollector->new;
$undef->add( 'DistName', sub { return } );
eval { $undef->DistName };
like( $@, qr/ABORT:Attribute 'DistName' is empty string/, 'return undef' );

my $array = Enbld::Target::AttributeCollector->new;
$array->add( 'DistName', sub { return [ 'archive' ] } );
eval { $array->DistName };
like( $@, qr/ABORT:Attribute 'DistName' isn't scalar value/,
                'return array reference' );

done_testing();
