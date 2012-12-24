# ABSTRACT: TODO

package Dancer::Factory::Engine;
{
    $Dancer::Factory::Engine::VERSION = '1.9999_01';
}
use strict;
use warnings;

use Carp 'croak';

sub create {
    my ($class, $type, $name, %options) = @_;

    $type = _camelize($type);
    $name = _camelize($name);
    my $engine_class = "Dancer::${type}::${name}";

    eval "use $engine_class";
    croak "Unable to load class for $type engine $name: $@" if $@;

    return $engine_class->new(%options);
}

sub _camelize {
    my ($value) = @_;

    my $camelized = '';
    for my $word (split /_/, $value) {
        $camelized .= ucfirst($word);
    }
    return $camelized;
}

1;

__END__

=pod

=head1 NAME

Dancer::Factory::Engine - TODO

=head1 VERSION

version 1.9999_01

=head1 AUTHOR

Dancer Core Developers

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Alexis Sukrieh.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
