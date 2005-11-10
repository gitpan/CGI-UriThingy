#!/usr/local/bin/perl -w
use 5.008;
use strict;
use warnings;
use utf8;

use Test::More tests => 15;

BEGIN {
    use_ok('CGI::UriThingy');
    use CGI::UriThingy qw(
        urlencode urldecode
        uri_escape uri_unescape
        );
};

my @Text = <DATA>;
@Text = split /\n<!-- CUT HERE -- CUT HERE -- CUT HERE -- CUT HERE -- CUT HERE -->\n/, join('', @Text);

########################################################################
my $text     = $Text[0];
my $expected = $Text[1];
my $count = $expected =~ tr/%/%/;

my $got = uri_escape($text);

is($got , $count  , 'uri_escape() return value');
is($text, $Text[1], 'uri_escape() escaped string');

########################################################################
$text     = $Text[1];
$expected = $Text[0];

$got = uri_unescape($text);

is($got , $count   , 'uri_unescape() return value' );
is($text, $expected, 'uri_unescape() unescaped string');

########################################################################
$text = $Text[0];

my @param = (
    name   => 'Masanori HATA'           ,
    mail   => 'lovewing@geocities.co.jp',
    sex    => 'male'                    ,
    birth  => '2005-11-05'              ,
    nation => 'Japan'                   ,
    pref   => 'Saitama'                 ,
    city   => 'Kawaguchi'               ,
    tel    => '+81-48-2XX-XXXX'         ,
    fax    => '+81-48-2XX-XXXX'         ,
    job    => 'student'                 ,
    role   => 'president'               ,
    hobby  => 'exaggeration'            ,
    text   => $text
    );

$got = urlencode(@param);

is($got, $Text[2], 'urlencode(@param)');

########################################################################
$text = $Text[2];

my @got = urldecode($text);

my $mismatch = 0;
for (my $i = 0; $i <= $#param; $i++) {
    unless ($got[$i] eq $param[$i]) {
        $mismatch = 1;
    }
}
is($mismatch, 0, 'urldecode(@param)');

########################################################################
my %param = @param;

my %got = urldecode( urlencode(%param) );

$mismatch = 0;
foreach my $key (keys %param) {
    unless ($got{$key} eq $param{$key}) {
        $mismatch = 1;
    }
}
is($mismatch, 0, 'urlencode(%param) then urldecode()');

########################################################################
# function uri_escape() with Kanji
$text = '畑 正憲';
$expected = $Text[3];
$count = $expected =~ tr/%/%/;

$got = uri_escape($text);

is($got , $count   , ' uri_escape() w/ Kanji return value');
is($text, $expected, 'uri_escape() w/ Kanji escaped string');

########################################################################
$text     = $Text[3];
$expected = '畑 正憲';

$got = uri_unescape($text);

is($got , $count   , 'uri_unescape() w/ Kanji return value' );
is($text, $expected, 'uri_unescape() w/ Kanji unescaped string');

########################################################################
$text = $Text[0];

@param = (
    名前   => '畑 正憲',
    メール => 'lovewing@geocities.co.jp',
    性別   => '男性',
    誕生日 => '2005-11-05',
    国籍   => '日本',
    県     => '埼玉',
    市     => '川口',
    電話   => '+81-48-2XX-XXXX',
    ＦＡＸ => '+81-48-2XX-XXXX',
    職業   => '生徒',
    役職   => '社長',
    趣味   => '誇大表現',
    文章   => $text
);

$got = urlencode(@param);

is($got, $Text[4], 'urlencode(@param) w/ Kanji');

########################################################################
$text = $Text[4];

@got = urldecode($text);

$mismatch = 0;
for (my $i = 0; $i <= $#param; $i++) {
    unless ($got[$i] eq $param[$i]) {
        $mismatch = 1;
    }
}
is($mismatch, 0, 'urldecode(@param) w/ Kanji');

########################################################################
%param = ();
%param = @param;

%got = ();
%got = urldecode( urlencode(%param) );

$mismatch = 0;
foreach my $key (keys %param) {
    unless ($got{$key} eq $param{$key}) {
        $mismatch = 1;
    }
}
is($mismatch, 0, 'urlencode(%param) then urldecode() w/ Kanji');

########################################################################
__END__
<h4><span class="index-def" title="application/x-www-form-urlencoded|content type::application/x-www-form-urlencoded"><a name= "didx-applicationx-www-form-urlencoded">application/x-www-form-urlencoded</a></span></h4>

<p>This is the default content type. Forms submitted with this content type must be encoded as follows:</p>

<ol>
<li>Control names and values are escaped. Space characters are replaced by <samp>`+'</samp>, and then reserved characters are escaped as described in <a rel="biblioentry" href="../references.html#ref-RFC1738" class="normref">[RFC1738]</a>, section 2.2: Non-alphanumeric characters are replaced by <samp>`%HH'</samp>, a percent sign and two hexadecimal digits representing the ASCII code of the character. Line breaks are represented as "CR LF" pairs (i.e., <samp>`%0D%0A'</samp>).</li>

<li>The control names/values are listed in the order they appear in the document. The name is separated from the value by <samp>`='</samp> and name/value pairs are separated from each other by <samp>`&amp;'</samp>.</li>
</ol>
<!-- CUT HERE -- CUT HERE -- CUT HERE -- CUT HERE -- CUT HERE -->
%3Ch4%3E%3Cspan%20class%3D%22index-def%22%20title%3D%22application%2Fx-www-form-urlencoded%7Ccontent%20type%3A%3Aapplication%2Fx-www-form-urlencoded%22%3E%3Ca%20name%3D%20%22didx-applicationx-www-form-urlencoded%22%3Eapplication%2Fx-www-form-urlencoded%3C%2Fa%3E%3C%2Fspan%3E%3C%2Fh4%3E%0A%0A%3Cp%3EThis%20is%20the%20default%20content%20type.%20Forms%20submitted%20with%20this%20content%20type%20must%20be%20encoded%20as%20follows%3A%3C%2Fp%3E%0A%0A%3Col%3E%0A%3Cli%3EControl%20names%20and%20values%20are%20escaped.%20Space%20characters%20are%20replaced%20by%20%3Csamp%3E%60%2B'%3C%2Fsamp%3E%2C%20and%20then%20reserved%20characters%20are%20escaped%20as%20described%20in%20%3Ca%20rel%3D%22biblioentry%22%20href%3D%22..%2Freferences.html%23ref-RFC1738%22%20class%3D%22normref%22%3E%5BRFC1738%5D%3C%2Fa%3E%2C%20section%202.2%3A%20Non-alphanumeric%20characters%20are%20replaced%20by%20%3Csamp%3E%60%25HH'%3C%2Fsamp%3E%2C%20a%20percent%20sign%20and%20two%20hexadecimal%20digits%20representing%20the%20ASCII%20code%20of%20the%20character.%20Line%20breaks%20are%20represented%20as%20%22CR%20LF%22%20pairs%20(i.e.%2C%20%3Csamp%3E%60%250D%250A'%3C%2Fsamp%3E).%3C%2Fli%3E%0A%0A%3Cli%3EThe%20control%20names%2Fvalues%20are%20listed%20in%20the%20order%20they%20appear%20in%20the%20document.%20The%20name%20is%20separated%20from%20the%20value%20by%20%3Csamp%3E%60%3D'%3C%2Fsamp%3E%20and%20name%2Fvalue%20pairs%20are%20separated%20from%20each%20other%20by%20%3Csamp%3E%60%26amp%3B'%3C%2Fsamp%3E.%3C%2Fli%3E%0A%3C%2Fol%3E
<!-- CUT HERE -- CUT HERE -- CUT HERE -- CUT HERE -- CUT HERE -->
name=Masanori+HATA&mail=lovewing%40geocities.co.jp&sex=male&birth=2005-11-05&nation=Japan&pref=Saitama&city=Kawaguchi&tel=%2B81-48-2XX-XXXX&fax=%2B81-48-2XX-XXXX&job=student&role=president&hobby=exaggeration&text=%3Ch4%3E%3Cspan+class%3D%22index-def%22+title%3D%22application%2Fx-www-form-urlencoded%7Ccontent+type%3A%3Aapplication%2Fx-www-form-urlencoded%22%3E%3Ca+name%3D+%22didx-applicationx-www-form-urlencoded%22%3Eapplication%2Fx-www-form-urlencoded%3C%2Fa%3E%3C%2Fspan%3E%3C%2Fh4%3E%0D%0A%0D%0A%3Cp%3EThis+is+the+default+content+type.+Forms+submitted+with+this+content+type+must+be+encoded+as+follows%3A%3C%2Fp%3E%0D%0A%0D%0A%3Col%3E%0D%0A%3Cli%3EControl+names+and+values+are+escaped.+Space+characters+are+replaced+by+%3Csamp%3E%60%2B'%3C%2Fsamp%3E%2C+and+then+reserved+characters+are+escaped+as+described+in+%3Ca+rel%3D%22biblioentry%22+href%3D%22..%2Freferences.html%23ref-RFC1738%22+class%3D%22normref%22%3E%5BRFC1738%5D%3C%2Fa%3E%2C+section+2.2%3A+Non-alphanumeric+characters+are+replaced+by+%3Csamp%3E%60%25HH'%3C%2Fsamp%3E%2C+a+percent+sign+and+two+hexadecimal+digits+representing+the+ASCII+code+of+the+character.+Line+breaks+are+represented+as+%22CR+LF%22+pairs+(i.e.%2C+%3Csamp%3E%60%250D%250A'%3C%2Fsamp%3E).%3C%2Fli%3E%0D%0A%0D%0A%3Cli%3EThe+control+names%2Fvalues+are+listed+in+the+order+they+appear+in+the+document.+The+name+is+separated+from+the+value+by+%3Csamp%3E%60%3D'%3C%2Fsamp%3E+and+name%2Fvalue+pairs+are+separated+from+each+other+by+%3Csamp%3E%60%26amp%3B'%3C%2Fsamp%3E.%3C%2Fli%3E%0D%0A%3C%2Fol%3E
<!-- CUT HERE -- CUT HERE -- CUT HERE -- CUT HERE -- CUT HERE -->
%E7%95%91%20%E6%AD%A3%E6%86%B2
<!-- CUT HERE -- CUT HERE -- CUT HERE -- CUT HERE -- CUT HERE -->
%E5%90%8D%E5%89%8D=%E7%95%91+%E6%AD%A3%E6%86%B2&%E3%83%A1%E3%83%BC%E3%83%AB=lovewing%40geocities.co.jp&%E6%80%A7%E5%88%A5=%E7%94%B7%E6%80%A7&%E8%AA%95%E7%94%9F%E6%97%A5=2005-11-05&%E5%9B%BD%E7%B1%8D=%E6%97%A5%E6%9C%AC&%E7%9C%8C=%E5%9F%BC%E7%8E%89&%E5%B8%82=%E5%B7%9D%E5%8F%A3&%E9%9B%BB%E8%A9%B1=%2B81-48-2XX-XXXX&%EF%BC%A6%EF%BC%A1%EF%BC%B8=%2B81-48-2XX-XXXX&%E8%81%B7%E6%A5%AD=%E7%94%9F%E5%BE%92&%E5%BD%B9%E8%81%B7=%E7%A4%BE%E9%95%B7&%E8%B6%A3%E5%91%B3=%E8%AA%87%E5%A4%A7%E8%A1%A8%E7%8F%BE&%E6%96%87%E7%AB%A0=%3Ch4%3E%3Cspan+class%3D%22index-def%22+title%3D%22application%2Fx-www-form-urlencoded%7Ccontent+type%3A%3Aapplication%2Fx-www-form-urlencoded%22%3E%3Ca+name%3D+%22didx-applicationx-www-form-urlencoded%22%3Eapplication%2Fx-www-form-urlencoded%3C%2Fa%3E%3C%2Fspan%3E%3C%2Fh4%3E%0D%0A%0D%0A%3Cp%3EThis+is+the+default+content+type.+Forms+submitted+with+this+content+type+must+be+encoded+as+follows%3A%3C%2Fp%3E%0D%0A%0D%0A%3Col%3E%0D%0A%3Cli%3EControl+names+and+values+are+escaped.+Space+characters+are+replaced+by+%3Csamp%3E%60%2B'%3C%2Fsamp%3E%2C+and+then+reserved+characters+are+escaped+as+described+in+%3Ca+rel%3D%22biblioentry%22+href%3D%22..%2Freferences.html%23ref-RFC1738%22+class%3D%22normref%22%3E%5BRFC1738%5D%3C%2Fa%3E%2C+section+2.2%3A+Non-alphanumeric+characters+are+replaced+by+%3Csamp%3E%60%25HH'%3C%2Fsamp%3E%2C+a+percent+sign+and+two+hexadecimal+digits+representing+the+ASCII+code+of+the+character.+Line+breaks+are+represented+as+%22CR+LF%22+pairs+(i.e.%2C+%3Csamp%3E%60%250D%250A'%3C%2Fsamp%3E).%3C%2Fli%3E%0D%0A%0D%0A%3Cli%3EThe+control+names%2Fvalues+are+listed+in+the+order+they+appear+in+the+document.+The+name+is+separated+from+the+value+by+%3Csamp%3E%60%3D'%3C%2Fsamp%3E+and+name%2Fvalue+pairs+are+separated+from+each+other+by+%3Csamp%3E%60%26amp%3B'%3C%2Fsamp%3E.%3C%2Fli%3E%0D%0A%3C%2Fol%3E
<!-- CUT HERE -- CUT HERE -- CUT HERE -- CUT HERE -- CUT HERE -->
