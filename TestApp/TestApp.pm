package TestApp;
use Dancer;

get '/' => sub {
    template 'index';
};

true;
