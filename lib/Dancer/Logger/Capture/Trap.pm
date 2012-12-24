# ABSTRACT: a place to store captured Dancer logs

package Dancer::Logger::Capture::Trap;
{
    $Dancer::Logger::Capture::Trap::VERSION = '1.9999_01';
}
use Moo;
use Dancer::Core::Types;

has storage => (
    is      => 'rw',
    isa     => ArrayRef,
    default => sub { [] },
);

sub store {
    my ($self, $level, $message) = @_;
    push @{$self->storage}, {level => $level, message => $message};
}

sub read {
    my $self = shift;

    my $logs = $self->storage;
    $self->storage([]);
    return $logs;
}

1;

__END__

=pod

=head1 NAME

Dancer::Logger::Capture::Trap - a place to store captured Dancer logs

=head1 VERSION

version 1.9999_01

=head1 SYNOPSIS

    my $trap = Dancer::Logger::Capture::Trap->new;
    $trap->store( $level, $message );
    my $logs = $trap->read;

=head1 DESCRIPTION

This is a place to store and retrieve capture Dancer logs used by
L<Dancer::Logger::Capture>.

=head2 Methods

=head3 new

=head3 store

    $trap->store($level, $message);

Stores a log $message and its $level.

=head3 read

    my $logs = $trap->read;

Returns the logs stored as an array ref and clears the storage.

For example...

    [{ level => "warning", message => "Danger! Warning! Dancer!" },
     { level => "error",   message => "You fail forever" }
    ];

=head1 SEE ALSO

L<Dancer::Logger::Capture>

=head1 AUTHOR

Dancer Core Developers

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Alexis Sukrieh.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
