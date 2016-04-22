#!/usr/bin/perl

# 引数に指定したRSSと秒数から指定秒以内のtitle/urlを表示
# 指定秒が0の場合全てのエントリ分を表示
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

my $TIME = time;

if (@ARGV != 2) {
  die "USAGE: $0 rss interval(Second)\n";
}
my $RSS = $ARGV[0];
my $INTERVAL = $ARGV[1];
if (!looks_like_number $INTERVAL){
  die "USAGE: $0 rss interval(Second)\n";
}

my $content = get( $RSS );
die "RSS Couldn't get it!" unless defined $content;

my $rss = XML::RSS->new;
$rss -> parse( $content );

foreach my $item ( @{$rss -> {'items'}} ){
  my $pdate;
  if($item->{'pubDate'}) {
    $pdate = DateTime::Format::HTTP->parse_datetime($item->{'pubDate'});
  } elsif ( $item->{'dc'}->{'date'} ) {
    $pdate = DateTime::Format::HTTP->parse_datetime($item->{'dc'}->{'date'});
  } else {
    die "unknown Time.\n";
  }
  if(($pdate->epoch > ($TIME - $INTERVAL)) ||
     ( $INTERVAL == 0)) {
    print '"' . Encode::encode('utf8', $item->{'title'}),"\" $item->{'link'}\n";
  }else{ exit }
}

