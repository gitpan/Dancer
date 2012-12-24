package Dancer::Core::Request::Upload;
{
    $Dancer::Core::Request::Upload::VERSION = '1.9999_02';
}

# ABSTRACT: Class representing file upload requests
use Moo;
use Dancer::Core::Types;

use Carp;
use File::Spec;
use Dancer::FileUtils qw(open_file);


has filename => (
    is  => 'rw',
    isa => Str,
);


has tempname => (
    is  => 'rw',
    isa => Str,
);


has headers => (
    is  => 'rw',
    isa => HashRef,
);


has size => (
    is  => 'rw',
    isa => Num,
);


sub file_handle {
    my ($self) = @_;
    return $self->{_fh} if defined $self->{_fh};
    my $fh = open_file('<', $self->tempname);
    $self->{_fh} = $fh;
}


sub copy_to {
    my ($self, $target) = @_;
    require File::Copy;
    File::Copy::copy($self->{tempname}, $target);
}


sub link_to {
    my ($self, $target) = @_;
    CORE::link($self->{tempname}, $target);
}


sub content {
    my ($self, $layer) = @_;
    return $self->{_content}
      if defined $self->{_content};

    $layer = ':raw' unless $layer;

    my $content = undef;
    my $handle  = $self->file_handle;

    binmode($handle, $layer);

    while ($handle->read(my $buffer, 8192)) {
        $content .= $buffer;
    }

    $self->{_content} = $content;
}


sub basename {
    my ($self) = @_;
    require File::Basename;
    File::Basename::basename($self->filename);
}


sub type {
    my $self = shift;
    return $self->headers->{'Content-Type'};
}

1;

__END__

=pod

=head1 NAME

Dancer::Core::Request::Upload - Class representing file upload requests

=head1 VERSION

version 1.9999_02

=head1 DESCRIPTION

This class implements a representation of file uploads for Dancer.
These objects are accessible within route handlers via the request->uploads
keyword. See L<Dancer::Request> for details.

=head1 ATTRIBUTES

=head2 filename

Filename as sent by client. optional. May not be undef.

=head2 tempname

The name of the temporary file the data has been saved to. Optional. May not be undef.

=head2 headers

A hash ref of the headers associated with this upload. optional. is read-write and a HashRef.

=head2 size

The size of the upload, in bytes. Optional.

=head1 METHODS

=head2 my $filename=$upload->filename;

Returns the filename (full path) as sent by the client.

=head2 my $tempname=$upload->tempname;

Returns the name of the temporary file the data has been saved to.

For example, in directory /tmp, and given a random name, with no file extension.

=head2 my $href=$upload->headers;

Returns a hashRef of the headers associated with this upload.

=head2 my $fh=$upload->file_handle;

Returns a read-only file handle on the temporary file.

=head2 $upload->copy_to('/path/to/target')

Copies the temporary file using File::Copy. Returns true for success,
false for failure.

=head2 $upload->link_to('/path/to/target');

Creates a hard link to the temporary file. Returns true for success,
false for failure.

=head2 my $content=$upload->content;

Returns a scalar containing the contents of the temporary file.

=head2 my $basename=$upload->basename;

Returns basename for "filename".

=head2 $upload->type

Returns the Content-Type of this upload.

=head1 SEE ALSO

L<Dancer>

=head1 AUTHOR

Dancer Core Developers

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Alexis Sukrieh.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
