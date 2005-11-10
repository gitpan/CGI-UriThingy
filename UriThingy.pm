package CGI::UriThingy;
########################################################################
# Copyright (c) 1999-2005 Masanori HATA. All rights reserved.
# <http://go.to/hata>
########################################################################

#### Pragmas ###########################################################
use 5.008;
use strict;
use warnings;
#### Standard Libraries ################################################
require Exporter;
our @ISA = 'Exporter';
our @EXPORT_OK = qw(
    urlencode urldecode
    uri_escape uri_unescape
);

use Carp;
########################################################################

#### Constants #########################################################
our $VERSION = '0.08'; # 2005-11-10 (since 1999)
########################################################################

=head1 NAME

CGI::UriThingy - a fewest set of functions about uri thingies.

=head1 SYNOPSIS

 use CGI::UriThingy qw(urlencode urldecode);
 
 my %input = (
     'name' => 'Masanori HATA',
     'mail' => 'lovewing@dream.big.or.jp',
     'home' => 'http://go.to/hata',
     );
 my $encoded = urlencode(%input);
 print $encoded;
 
 my %output = urldecode($encoded);
 print 'name: ', $output{'name'}; # displays "name: Masanori HATA"

=head1 DESCRIPTION

This module provides four minimal functions about urlencode and uri-escape those which could be needed for CGI program.

=head1 FUNCTIONS

=over

=item urlencode(%param)

Exportable function. With given C<%param> (the names and the values pairs), this function escape, combine and return urlencoded string. A urlencoded string has jointed the names and the value pairs by "&" character, and a name/value pair has jointed the name and the value by "=" character.

Though it is expressed virtually input with a hash (%), it is actually input with an arry (@). So, jointed name/value pairs appear in urlencoded string be in exact sequence of which they have been given. That you can control sequence of name/value pairs appear in urlencoded string. If you just give a real hash (%) to this function, order of name/value pairs appear in urlencoded string should be random.

 $encoded = urlencode(
     name1 => value1,
     name2 => value2,
     (...)
 );
 
 $encoded = "name1=value1&name2=value2&(...)";

Note that the C<application/x-www-form-urlencoded> is specified in HTML 4 L<http://www.w3.org/TR/html4/interact/forms.html#h-17.13.4.1>.

=cut

sub urlencode (@) {
    my @attr = @_;
    if (@attr % 2 == 1) {
        croak 'odd: total number of given arguments must be even one';
    }
    
    my @pair;
    for (my $i = 0; $i < $#attr; $i += 2) {
        my($name, $value) = ($attr[$i], $attr[$i + 1]);
        _url_escape($name );
        _url_escape($value);
        push @pair, "$name=$value";
    }
    
    return join('&', @pair);
}

sub _url_escape ($) {
    # build conversion map
    my %hexhex;
    for (my $i = 0; $i <= 255; $i++) {
        $hexhex{chr($i)} = sprintf('%02X', $i);
    }
    
    utf8::encode($_[0]);
    $_[0] =~ s/\n/\x0D\x0A/g;
    $_[0] =~ s/([^0-9A-Za-z\-_.!~*'() ])/%$hexhex{$1}/og;
    $_[0] =~ tr/ /+/;
    utf8::decode($_[0]);
    
    return 1;
}

=item urldecode($string)

Exportable function. This function decode and return names/values pairs from given uri-encoded string. You may input them into a hash (%).

 %param = urldecode($encoded);

=cut

sub urldecode ($) {
    my @n_v_pair = split /&/, shift;
    
    my @n_v;
    foreach my $pair (@n_v_pair) {
        push @n_v, split /=/, $pair;
    }
    
    foreach my $string (@n_v) {
        $string =~ tr/+/ /;
        uri_unescape($string);
        $string =~ s/\x0D\x0A/\n/g;
    }
    
    return @n_v;
}

=item uri_escape($string)

Exportable function. This function escape given string. A return value of this function is total number of escaped characters. The uri-escape is specified in RFC 2396 L<http://www.ietf.org/rfc/rfc2396.txt> (and it is partially updated by RFC 2732). The module L<URI::Escape> does a similar function.

=cut

sub uri_escape ($) {
    # build conversion map
    my %hexhex;
    for (my $i = 0; $i <= 255; $i++) {
        $hexhex{chr($i)} = sprintf('%02X', $i);
    }
    
    # $Reserved = ';/?:@&=+$,[]'; # [^$Reserved] != [$Unreserved]
    # note: "[" and "]" was added in RFC 2732
    # $Alphanum = '0-9A-Za-z';
    # $Mark = q/-_.!~*'()/;
    # $Unreserved = $Alphanum . $Mark;
    my $Unreserved = q/0-9A-Za-z\-_.!~*'()/;
    
    utf8::encode($_[0]);
    my $count = $_[0] =~ s/([^$Unreserved])/%$hexhex{$1}/og;
    utf8::decode($_[0]);
    
    return $count;
}

=item uri_unescape($string)

Exportable function. This function unescape given uri-escaped string. A return value of this function is total number of unescaped characters.

=cut

sub uri_unescape ($) {
    # build conversion map
    my %unescaped;
    for (my $i = 0; $i <= 255; $i++) {
        $unescaped{ sprintf('%02X', $i) } = chr($i); # for %HH
        $unescaped{ sprintf('%02x', $i) } = chr($i); # for %hh
    }
    
    utf8::encode($_[0]);
    my $count = $_[0] =~ s/%([0-9A-Fa-f]{2})/$unescaped{$1}/g;
    utf8::decode($_[0]);
    
    return $count;
}

1;
__END__

=back

=head1 SEE ALSO

=over

=item HTML 4: L<http://www.w3.org/TR/html4/interact/forms.html#h-17.13.4.1>

=item RFC 2396: L<http://www.ietf.org/rfc/rfc2396.txt>

=item RFC 2732: L<http://www.ietf.org/rfc/rfc2732.txt>

=back

=head1 AUTHOR

Masanori HATA L<http://go.to/hata> (Saitama, JAPAN)

=head1 COPYRIGHT

Copyright (c) 1999-2005 Masanori HATA. All rights reserved.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut

