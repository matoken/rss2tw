#!/usr/bin/perl

# ask.libreoffice.orgのRSSから最新5分以内のtitle/urlを表示
# crontabで5分毎に実行してtw.plやttytterに繋ぐのを想定
#
#   $ ./rss2tw.pl
#   IFTTTによるTwitter自動投稿の試験 http://ask.libreoffice.org/ja/question/68505/iftttniyorutwitterzi-dong-tou-gao-noshi-yan/
#   $ ./rss2tw.pl | tw
#
# KenichiroMATOHARA <matoken@gmail.com>

use strict;
use warnings;
use Encode;
use LWP::Simple;
use XML::RSS;
use DateTime::Format::HTTP;


my $RSS = 'https://ask.libreoffice.org/ja/feeds/rss/';
my $INTERVAL = 300;

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

