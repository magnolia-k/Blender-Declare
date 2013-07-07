#!/usr/bin/perl

use 5.012;
use warnings;

use Test::More;
use Test::Blender::Definition;

SKIP: {
          skip "Skip build Pkgconfig test because none of test env.",
               1 unless ( $ENV{PERL_BLENDER_TEST_DEFINITION} );
           
           build_ok( 'pkgconfig', undef, 'first test' );

       };

done_testing();