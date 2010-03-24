# PSGI application bootstraper for Dancer
use lib '/home/sukria/Devel/Dancer/TestApp';
use TestApp;

use Dancer::Config 'setting';
setting apphandler  => 'PSGI';
Dancer::Config->load;

my $handler = sub {
    my $env = shift;
    my $request = Dancer::Request->new($env);
    Dancer->dance($request);
};
