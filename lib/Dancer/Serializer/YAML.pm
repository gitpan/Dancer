# ABSTRACT: Serializer for handling YAML data

package Dancer::Serializer::YAML;
{
    $Dancer::Serializer::YAML::VERSION = '1.9999_02';
}
use Moo;
use Carp 'croak';
with 'Dancer::Core::Role::Serializer';

# helpers

sub from_yaml {
    my ($yaml) = @_;
    my $s = Dancer::Serializer::YAML->new;
    $s->deserialize($yaml);
}

sub to_yaml {
    my ($data) = @_;
    my $s = Dancer::Serializer::YAML->new;
    $s->serialize($data);
}

# class definition

sub BUILD { eval "use YAML::Any ()"; croak "Fail to load YAML: $@" if $@ }
sub loaded {1}

sub serialize {
    my ($self, $entity) = @_;
    YAML::Any::Dump($entity);
}

sub deserialize {
    my ($self, $content) = @_;
    YAML::Any::Load($content);
}

sub content_type {'text/x-yaml'}

1;

__END__

=pod

=head1 NAME

Dancer::Serializer::YAML - Serializer for handling YAML data

=head1 VERSION

version 1.9999_02

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 serialize

Serialize a data structure to a YAML structure.

=head2 deserialize

Deserialize a YAML structure to a data structure

=head2 content_type

Return 'text/x-yaml'

=head1 AUTHOR

Dancer Core Developers

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Alexis Sukrieh.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
