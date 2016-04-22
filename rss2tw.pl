#!/usr/bin/perl

# 引数に指定したRSSから指定秒以内のtitle/urlを表示
# crontabで定期的に実行してtw.plやttytterに繋ぐのを想定
#
#   $ ./rss2tw.pl http://matoken.org/blog/feed/rss/ 999999
#   "Bash on Ubuntu on Windows(Windows Subsystem for linux)を少し試す" http://matoken.org/blog/blog/2016/04/14/try-bash-on-ubuntu-on-windowswindows-subsystem-for-linux/
#   $ ./rss2tw.pl | tw
#
# KenichiroMATOHARA <matoken@gmail.com>

use strict;
use warnings;
use Encode;
use LWP::Simple;
use XML::RSS;
use DateTime::Format::HTTP;
use Scalar::Util qw(looks_like_number);


if (@ARGV != 2) {
  die "USAGE: $0 rss interval(Second)\n";
}
my $RSS = $ARGV[0];
my $INTERVAL = $ARGV[1];
if (!looks_like_number $INTERVAL){
  die "USAGE: $0 rss interval(Second)\n";
}

my $content = get( $RSS );
die "Couldn't get it!" unless defined $content;

my $rss = XML::RSS->new;
$rss -> parse( $content );

foreach my $item ( @{$rss -> {'items'}} ){
  my $pubdate = DateTime::Format::HTTP->parse_datetime($item->{'pubDate'});
  if($pubdate->epoch > (time - $INTERVAL) ){
    print '"' . Encode::encode('utf8', $item->{'title'}),"\" $item->{'link'}\n";
  }else{ exit }
}

