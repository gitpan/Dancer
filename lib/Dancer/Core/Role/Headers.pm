# ABSTRACT: TODO

package Dancer::Core::Role::Headers;
{
    $Dancer::Core::Role::Headers::VERSION = '1.9999_02';
}

use Moo::Role;
use Dancer::Core::Types;
use HTTP::Headers;

has headers => (
    is     => 'rw',
    isa    => InstanceOf ['HTTP::Headers'],
    lazy   => 1,
    coerce => sub {
        my ($value) = @_;
        return $value if ref($value) eq 'HTTP::Headers';
        HTTP::Headers->new(@{$value});
    },
    default => sub {
        HTTP::Headers->new();
    },
);

sub header {
    my $self   = shift;
    my $header = shift;

    if (@_) {
        $self->headers->header($header => @_);
    }
    else {
        return $self->headers->header($header);
    }
}

sub push_header {
    my $self   = shift;
    my $header = shift;

    if (@_) {
        foreach my $h (@_) {
            $self->headers->push_header($header => $h);
        }
    }
    else {
        return $self->headers->header($header);
    }
}

sub headers_to_array {
    my $self = shift;

    my $headers = [
        map {
            my $k = $_;
            map {
                my $v = $_;
                $v =~ s/^(.+)\r?\n(.*)$/$1\r\n $2/;
                ($k => $v)
            } $self->headers->header($_);
        } $self->headers->header_field_names
    ];

    return $headers;
}

1;

__END__

=pod

=head1 NAME

Dancer::Core::Role::Headers - TODO

=head1 VERSION

version 1.9999_02

=head1 AUTHOR

Dancer Core Developers

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Alexis Sukrieh.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
