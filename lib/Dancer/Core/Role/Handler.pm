# ABSTRACT: TODO

package Dancer::Core::Role::Handler;
{
    $Dancer::Core::Role::Handler::VERSION = '1.9999_01';
}
use Moo::Role;
use Dancer::Core::Types;

requires 'register';

has app => (
    is  => 'ro',
    isa => InstanceOf ['Dancer::Core::App'],
);

1;

__END__

=pod

=head1 NAME

Dancer::Core::Role::Handler - TODO

=head1 VERSION

version 1.9999_01

=head1 AUTHOR

Dancer Core Developers

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Alexis Sukrieh.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
