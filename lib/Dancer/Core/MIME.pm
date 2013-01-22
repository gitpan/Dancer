package Dancer::Core::MIME;
{
    $Dancer::Core::MIME::VERSION = '2.0000_01';
}

# ABSTRACT: TODO

use strict;
use warnings;

use Moo;
use Dancer::Core::Types;
use Carp 'croak';
use MIME::Types;

# Initialise MIME::Types at compile time, to ensure it's done before
# the fork in a preforking webserver like mod_perl or Starman. Not
# doing this leads to all MIME types being returned as "text/plain",
# as MIME::Types fails to load its mappings from the DATA handle. See
# t/04_static_file/003_mime_types_reinit.t and GH#136.
BEGIN {
    MIME::Types->new(only_complete => 1);
}

has mime_type => (
    is      => 'ro',
    isa     => InstanceOf ['MIME::Types'],
    default => sub { MIME::Types->new(only_complete => 1) },
    lazy    => 1,
);

has custom_types => (
    is      => 'rw',
    isa     => HashRef,
    default => sub { +{} },
);

has default => (
    is      => 'rw',
    isa     => Str,
    builder => "reset_default",
);

sub reset_default {
    my ($self) = @_;
    $self->default("application/data");
}

sub add_type {
    my ($self, $name, $type) = @_;
    $self->custom_types->{$name} = $type;
    return;
}

sub add_alias {
    my ($self, $alias, $orig) = @_;
    my $type = $self->for_name($orig);
    $self->add_type($alias, $type);
    return $type;
}

sub for_file {
    my ($self, $filename) = @_;
    my ($ext) = $filename =~ /\.([^.]+)$/;
    return $self->default unless $ext;
    return $self->for_name($ext);
}

sub name_or_type {
    my ($self, $name) = @_;

    return $name if $name =~ m{/};    # probably a mime type
    return $self->for_name($name);
}

sub for_name {
    my ($self, $name) = @_;
    return
         $self->custom_types->{lc $name}
      || $self->mime_type->mimeTypeOf(lc $name)
      || $self->default;
}

1;

__END__

=pod

=head1 NAME

Dancer::Core::MIME - TODO

=head1 VERSION

version 2.0000_01

=head1 AUTHOR

Dancer Core Developers

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Alexis Sukrieh.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
