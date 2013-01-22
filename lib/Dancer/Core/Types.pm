package Dancer::Core::Types;
{
    $Dancer::Core::Types::VERSION = '2.0000_01';
}

# ABSTRACT: Moo types for Dancer core.

use strict;
use warnings;
use Scalar::Util 'blessed', 'looks_like_number';
use MooX::Types::MooseLike 0.16 'exception_message';
use MooX::Types::MooseLike::Base qw/:all/;
use MooX::Types::MooseLike::Numeric qw/:all/;

use Exporter 'import';
our @EXPORT;
our @EXPORT_OK;


my $single_part = qr/
    [A-Za-z]              # must start with letter
    (?: [A-Za-z0-9_]+ )? # can continue with letters, numbers or underscore
/x;

my $namespace = qr/
    ^
    $single_part                    # first part
    (?: (?: \:\: $single_part )+ )? # optional part starting with double colon
    $
/x;


my $definitions = [
    {   name    => 'ReadableFilePath',
        test    => sub { -e $_[0] && -r $_[0] },
        message => sub { return exception_message($_[0], 'ReadableFilePath') }
    },
    {   name    => 'WritableFilePath',
        test    => sub { -e $_[0] && -w $_[0] },
        message => sub { return exception_message($_[0], 'WritableFilePath') }
    },

    # Dancer-specific types
    {   name       => 'DancerPrefix',
        subtype_of => 'Str',
        from       => 'MooX::Types::MooseLike::Base',
        test       => sub {

            # a prefix must start with the char '/'
            # index is much faster than =~ /^\//
            index($_[0], '/') == 0;
        },
        message => sub { return exception_message($_[0], 'a DancerPrefix') }
    },
    {   name       => 'DancerAppName',
        subtype_of => 'Str',
        from       => 'MooX::Types::MooseLike::Base',
        test       => sub {

            # TODO need a real check of valid app names
            $_[0] =~ $namespace;
        },
        message => sub {
            return exception_message(length($_[0]) ? $_[0] : 'Empty string',
                'a DancerAppName');
          }
    },
    {   name       => 'DancerMethod',
        subtype_of => 'Str',
        from       => 'MooX::Types::MooseLike::Base',
        test       => sub {
            grep {/^$_[0]$/} qw(get head post put delete options patch);
        },
        message => sub { return exception_message($_[0], 'a DancerMethod') }
    },
    {   name       => 'DancerHTTPMethod',
        subtype_of => 'Str',
        from       => 'MooX::Types::MooseLike::Base',
        test       => sub {
            grep {/^$_[0]$/} qw(GET HEAD POST PUT DELETE OPTIONS PATCH);
        },
        message =>
          sub { return exception_message($_[0], 'a DancerHTTPMethod') }
    },
];

# generate abbreviated class types for core dancer objects
for my $type (
    qw/
    App
    Context
    Cookie
    DSL
    Dispatcher
    Error
    Hook
    MIME
    Request
    Response
    Role
    Route
    Runner
    Server
    Session
    Types
    /
  )
{
    push @$definitions, {
        name => $type,
        test => sub {
            return
                 $_[0]
              && blessed($_[0])
              && ref($_[0]) eq 'Dancer::Core::' . $type;
        },
        message =>
          sub {"The value `$_[0]' does not pass the constraint check."}
    };
}

MooX::Types::MooseLike::register_types($definitions, __PACKAGE__);

# Export everything by default.
@EXPORT = (@MooX::Types::MooseLike::Base::EXPORT_OK, @EXPORT_OK);

1;

__END__

=pod

=head1 NAME

Dancer::Core::Types - Moo types for Dancer core.

=head1 VERSION

version 2.0000_01

=head1 DESCRIPTION

Type definitions for Moo attributes. These are defined as subroutines. 

=head1 MOO TYPES 

=head2 ReadableFilePath($value)

A readable file path.

=head2 WritableFilePath($value)

A writable file path.

=head2 DancerPrefix($value)

A proper Dancer prefix, which is basically a prefix that starts with a I</>
character.

=head2 DancerAppName($value)

A proper Dancer application name.

Currently this only checks for I<\w+>.

=head2 DancerMethod($value)

An acceptable method supported by Dancer.

Currently this includes: I<get>, I<head>, I<post>, I<put>, I<delete> and
I<options>.

=head2 DancerHTTPMethod($value)

An acceptable HTTP method supported by Dancer.

Current this includes: I<GET>, I<HEAD>, I<POST>, I<PUT>, I<DELETE>
and I<OPTIONS>.

=head1 SEE ALSO

L<MooX::Types::MooseLike> for more available types

=head1 AUTHOR

Dancer Core Developers

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Alexis Sukrieh.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
