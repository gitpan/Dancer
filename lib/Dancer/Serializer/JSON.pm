# ABSTRACT: Serializer for handling JSON data

package Dancer::Serializer::JSON;
{
    $Dancer::Serializer::JSON::VERSION = '1.9999_01';
}
use Moo;
use JSON ();

with 'Dancer::Core::Role::Serializer';


# helpers
sub from_json {
    my $s = Dancer::Serializer::JSON->new;
    $s->deserialize(@_);
}

sub to_json {
    my $s = Dancer::Serializer::JSON->new;
    $s->serialize(@_);
}

# class definition
sub loaded {1}


sub serialize {
    my ($self, $entity, $options) = @_;

    # Why doesn't $self->config have this?
    my $config = $self->config;

    if ($config->{allow_blessed} && !defined $options->{allow_blessed}) {
        $options->{allow_blessed} = $config->{allow_blessed};
    }
    if ($config->{convert_blessed}) {
        $options->{convert_blessed} = $config->{convert_blessed};
    }

    JSON::to_json($entity, $options);
}


sub deserialize {
    my ($self, $entity, $options) = @_;
    JSON::from_json($entity, $options);
}


sub content_type {'application/json'}

1;

__END__

=pod

=head1 NAME

Dancer::Serializer::JSON - Serializer for handling JSON data

=head1 VERSION

version 1.9999_01

=head1 SYNOPSIS

=head1 DESCRIPTION

Turn Perl data structures into JSON output and vice-versa.

=head1 METHODS

=head2 serialize

Serialize a Perl data structure into a JSON string.

=head2 deserialize

Deserialize a JSON string into a Perl data structure

=head2 content_type

return 'application/json'

=head1 AUTHOR

Dancer Core Developers

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Alexis Sukrieh.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
