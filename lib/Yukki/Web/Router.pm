package Yukki::Web::Router;
use Moose;

extends 'Path::Router';

use Yukki::Web::Router::Route;

use Moose::Util::TypeConstraints qw( subtype where );
use List::MoreUtils qw( all );

=head1 NAME

Yukki::Web::Router - send requests to the correct controllers, yo

=cut

# Add support for slurpy variables, inline off because I haven't written the match
# generator function yet.
has '+route_class' => ( default => 'Yukki::Web::Router::Route' );
has '+inline'      => ( default => 0 );

has app => (
    is          => 'ro',
    isa         => 'Yukki',
    required    => 1,
    weak_ref    => 1,
    handles     => 'Yukki::Role::App',
);

sub BUILD {
    my $self = shift;

    $self->add_route('login/?:action' => (
        defaults => {
            action => 'page',
        },
        validations => {
            action => qr/^(?:page|submit|exit)$/,
        },
        target => $self->controller('Login'),
    ));

    $self->add_route('logout' => (
        defaults => {
            action => 'exit',
        },
        target => $self->controller('Login'),
    ));

    $self->add_route('page/:action/:repository/*:page' => (
        defaults => {
            action     => 'view',
            repository => 'main',
            page       => [ 'home' ],
        },
        validations => {
            action     => qr/^(?:view|edit)$/,
            repository => qr/^[_a-z0-9]+$/i,
            page       => subtype('ArrayRef[Str]' => where {
                all { /^[_a-z0-9-]+(?:\.[_a-z0-9-]+)*$/i } @$_
            }),
        },
        target => $self->controller('Page'),
    ));
}

1;
