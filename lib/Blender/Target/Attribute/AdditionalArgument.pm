package Blender::Target::Attribute::AdditionalArgument;

use 5.012;
use warnings;

use parent qw/Blender::Target::AttributeExtension::Command/;

sub is_omitable {
    return 1;
}

1;