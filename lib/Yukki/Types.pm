package Yukki::Types;
use Moose;

use MooseX::Types -declare => [ qw(
    LoginName AccessLevel
) ];

use MooseX::Types::Moose qw( Str );

subtype LoginName,
    as Str,
    where { /^[a-z0-9]+$/ },
    message { "login name $_ must only contain letters and numbers" };

enum AccessLevel, qw( read write none );

1;
