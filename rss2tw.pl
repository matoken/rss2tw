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

my ($title, $link)= ('', '');
foreach my $line ( `curl -s -S https://ask.libreoffice.org/ja/feeds/rss/ | xmllint --format - | egrep '<title>|<link>|<pubDate>' | tail -n +3 | cut -c7-` ){
  chomp $line;
  if(    $line =~/\<title\>/   ){ $title = $line; $title =~s/<[^>]*>//g; }
  elsif( $line =~/\<link\>/    ){ $link  = $line; $link  =~s/<[^>]*>//g; }
  elsif( $line =~/\<pubDate\>/ ){
    $line=~s/<[^>]*>//g;
    my $date  = `printf \`date --date='$line' +%s\``;
    my $now_time = `printf \`date +%s\``;

    if($date > ($now_time-300) ){
      print "$title $link\n";
    }else{ exit }
  }else{ print "error\n" }
}

