use 5.008;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'         => 'CGI::UriThingy',
    'VERSION_FROM' => 'UriThingy.pm',
    ($] >= 5.005 ? (
        'ABSTRACT' => 'a fewest set of functions about uri thingies',
        'AUTHOR'   => 'Masanori HATA <http://go.to/hata>',
        ) : ()),
);
