#!/usr/bin/perl

use 5.012;
use warnings;

use Test::More;
use Test::Exception;

require_ok( 'Enbld::Error' );

throws_ok { 
    die Enbld::Error->new( 'error message' );
} qr/ERROR:error message\n/, 'captured message';

done_testing();
