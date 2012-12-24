# ABSTRACT: TODO

package Dancer::Core::Role::Engine;
{
    $Dancer::Core::Role::Engine::VERSION = '1.9999_01';
}
use Moo::Role;
use Dancer::Core::Types;

with 'Dancer::Core::Role::Hookable';

has type => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);

has environment => (is => 'ro');
has location    => (is => 'ro');

has context => (
    is        => 'rw',
    isa       => InstanceOf ['Dancer::Core::Context'],
    clearer   => 'clear_context',
    predicate => 1,
);

has config => (
    is      => 'rw',
    isa     => HashRef,
    default => sub { {} },
);

requires '_build_type';

1;

__END__

=pod

=head1 NAME

Dancer::Core::Role::Engine - TODO

=head1 VERSION

version 1.9999_01

=head1 AUTHOR

Dancer Core Developers

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Alexis Sukrieh.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
