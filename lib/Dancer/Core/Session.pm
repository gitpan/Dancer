package Dancer::Core::Session;
{
    $Dancer::Core::Session::VERSION = '1.9999_01';
}

#ABSTRACT: class to represent any session object


use strict;
use warnings;
use Moo;
use Dancer::Core::Types;


has id => (
    is       => 'rw',
    isa      => Str,
    required => 1,
);


sub read {
    my ($self, $key) = @_;
    return $self->data->{$key};
}


sub write {
    my ($self, $key, $value) = @_;
    $self->data->{$key} = $value;
}


has is_secure => (
    is      => 'rw',
    isa     => Bool,
    default => sub {0},
);


has is_http_only => (
    is      => 'rw',
    isa     => Bool,
    default => sub {1},
);


has expires => (
    is  => 'rw',
    isa => Str,
);


has data => (
    is      => 'rw',
    lazy    => 1,
    default => sub { {} },
);


has creation_time => (
    is      => 'ro',
    default => sub { time() },
);


sub cookie {
    my ($self) = @_;

    my %cookie = (
        name      => 'dancer.session',
        value     => $self->id,
        secure    => $self->is_secure,
        http_only => $self->is_http_only,
    );

    if (my $expires = $self->expires) {
        $cookie{expires} = $expires;
    }

    return Dancer::Core::Cookie->new(%cookie);
}


1;

__END__

=pod

=head1 NAME

Dancer::Core::Session - class to represent any session object

=head1 VERSION

version 1.9999_01

=head1 DESCRIPTION

A session object encapsulates anything related to a specific session: it's ID,
its data, creation timestampe...

It is completely agnostic of how it will be stored, this is the role of
a factory that consumes L<Dancer::Core::Role::SessionFactory> to know about that.

Generally, session objects should not be created directly.  The correct way to
get a new session object is to call the C<create()> method on a session engine
that implements the SessionFactory role.  This is done automatically by the
context object if a session engine is defined.

=head1 ATTRIBUTES

=head2 id

The identifier of the session object. Required. By default,
L<Dancer::Core::Role::SessionFactory> sets this to a randomly-generated,
guaranteed-unique string.

=head2 is_secure 

Boolean flag to tell if the session cookie is secure or not.

Default is false.

=head2 is_http_only

Boolean flag to tell if the session cookie is http only.

Default is true.

=head2 expires

Timestamp for the expiry of the session cookie.

Default is no expiry (session cookie will leave for the whole browser's
session).

=head2 data

Contains the data of the session (Hash).

=head2 creation_time

A timestamp of the moment when the session was created.

=head1 METHODS

=head2 read

Reader on the session data

    my $value = $session->read('something');

=head2 write

Writer on the session data

=head2 cookie

Coerce the session object into a L<Dancer::Core::Cookie> object.

=head1 AUTHOR

Dancer Core Developers

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Alexis Sukrieh.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
