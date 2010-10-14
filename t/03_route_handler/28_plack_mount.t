use strict;
use warnings;
use Test::More import => ['!pass'];

BEGIN {
    use Dancer::ModuleLoader;

    plan skip_all => "TEST::TCP is needed to run this test"
      unless Dancer::ModuleLoader->load('Test::TCP');
    plan skip_all => "Plack is needed to run this test"
      unless Dancer::ModuleLoader->load('Plack::Builder');
    plan skip_all => "HTTP::Request is needed to run this test"
      unless Dancer::ModuleLoader->load('HTTP::Request');
    plan skip_all => "LWP::UserAgent is needed to run this test"
      unless Dancer::ModuleLoader->load('LWP::UserAgent');
}

use Plack::Builder; # should be loaded in BEGIN block, but it seems that it's not the case ...
use HTTP::Server::Simple::PSGI;

plan tests => 3;

Test::TCP::test_tcp(
    client => sub {
        my $port = shift;
        my $url = "http://127.0.0.1:$port/mount/test/foo";

        my $req = HTTP::Request->new(GET => $url);
        my $ua = LWP::UserAgent->new();
        ok my $res = $ua->request($req);
        ok $res->is_success;
        is $res->content, '/foo';
    },
    server => sub {
        my $port    = shift;

        my $handler = sub {
            use Dancer ':setting';

            setting port       => $port;
            setting apphandler => 'PSGI';
            setting access_log => 0;

            get '/foo' => sub {request->path_info};

            my $env     = shift;
            my $request = Dancer::Request->new($env);
            Dancer->dance($request);
        };

        my $app = builder {
            mount "/mount/test" => $handler;
        };

        my $server = HTTP::Server::Simple::PSGI->new($port);
        $server->host("127.0.0.1");
        $server->app($app);
        $server->run;
    },
);
