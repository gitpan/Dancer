# ABSTRACT: TODO

package Dancer2::Logger::Console;
{
  $Dancer2::Logger::Console::VERSION = '2.000001';
}
use Moo;
with 'Dancer2::Core::Role::Logger';

sub log {
    my ($self, $level, $message) = @_;
    print STDERR $self->format_message($level => $message);
}

1;

__END__
=pod

=head1 NAME

Dancer2::Logger::Console - TODO

=head1 VERSION

version 2.000001

=head1 AUTHOR

Dancer Core Developers

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Alexis Sukrieh.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

