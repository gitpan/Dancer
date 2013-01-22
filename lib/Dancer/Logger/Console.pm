# ABSTRACT: TODO

package Dancer::Logger::Console;
{
    $Dancer::Logger::Console::VERSION = '2.0000_01';
}
use Moo;
with 'Dancer::Core::Role::Logger';

sub log {
    my ($self, $level, $message) = @_;
    print STDERR $self->format_message($level => $message);
}

1;

__END__

=pod

=head1 NAME

Dancer::Logger::Console - TODO

=head1 VERSION

version 2.0000_01

=head1 AUTHOR

Dancer Core Developers

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Alexis Sukrieh.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
