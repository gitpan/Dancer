# ABSTRACT: Blackhole-like silent logging engine for Dancer

package Dancer::Logger::Null;
{
    $Dancer::Logger::Null::VERSION = '2.0000_01';
}
use Moo;
with 'Dancer::Core::Role::Logger';


sub log {1}

1;

__END__

=pod

=head1 NAME

Dancer::Logger::Null - Blackhole-like silent logging engine for Dancer

=head1 VERSION

version 2.0000_01

=head1 DESCRIPTION

This logger acts as a blackhole (or /dev/null, if you will) that discards all
the log messages instead of displaying them anywhere.

=head1 METHODS

=head2 log

Discards the message.

=head1 AUTHOR

Dancer Core Developers

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Alexis Sukrieh.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
