# ABSTRACT: TODO

package Dancer::Core::Role::Serializer;
{
    $Dancer::Core::Role::Serializer::VERSION = '2.0000_01';
}
use Dancer::Core::Types;

use Moo::Role;
with 'Dancer::Core::Role::Engine';

sub supported_hooks {
    qw(
      engine.serializer.before
      engine.serializer.after
    );
}

sub _build_type {'Serializer'}

requires 'serialize';
requires 'deserialize';
requires 'loaded';

around serialize => sub {
    my ($orig, $self) = (shift, shift);
    my ($data) = @_;

    $self->execute_hook('engine.serializer.before', $data);
    my $serialized = $self->$orig($data);
    $self->execute_hook('engine.serializer.after', $serialized);

    return $serialized;
};

# attribute vs method?
sub content_type {'text/plain'}

# most serializer don't have to overload this one
sub support_content_type {
    my ($self, $ct) = @_;
    return unless $ct;

    my @toks = split ';', $ct;
    $ct = lc($toks[0]);
    return $ct eq $self->content_type;
}

1;

__END__

=pod

=head1 NAME

Dancer::Core::Role::Serializer - TODO

=head1 VERSION

version 2.0000_01

=head1 AUTHOR

Dancer Core Developers

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Alexis Sukrieh.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
