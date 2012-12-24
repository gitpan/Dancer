# ABSTRACT: Capture dancer logs

package Dancer::Logger::Capture;
{
    $Dancer::Logger::Capture::VERSION = '1.9999_01';
}
use Moo;
use Dancer::Logger::Capture::Trap;

with 'Dancer::Core::Role::Logger';


has trapper => (
    is      => 'ro',
    lazy    => 1,
    builder => '_build_trapper',
);

sub _build_trapper { Dancer::Logger::Capture::Trap->new }

sub log {
    my ($self, $level, $message) = @_;

    $self->trapper->store($level => $message);
    return;
}

1;

__END__

=pod

=head1 NAME

Dancer::Logger::Capture - Capture dancer logs

=head1 VERSION

version 1.9999_01

=head1 SYNOPSIS

    set logger => "capture";

    my $trap = Dancer::Logger::Capture->trap;
    my $logs = $trap->read;

	#a real-world example
    use Test::More import => ['!pass'], tests => 2;
    use Dancer;

    set logger => 'capture';

    warning "Danger!  Warning!";
    debug   "I like pie.";

    my $trap = Dancer::Logger::Capture->trap;
    is_deeply $trap->read, [
        { level => "warning", message => "Danger!  Warning!" },
        { level => "debug",   message => "I like pie.", }
    ];

    # each call to read cleans the trap
    is_deeply $trap->read, [];

=head1 DESCRIPTION

This is a logger class for L<Dancer> which captures all logs to an object.

It's primary purpose is for testing.

=head1 METHODS

=head2 trap

Returns the L<Dancer::Logger::Capture::Trap> object used to capture
and read logs.

=head1 SEE ALSO

L<Dancer::Logger>, L<Dancer::Logger::Capture::Trap>

=cut

=head1 AUTHOR

Dancer Core Developers

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Alexis Sukrieh.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
