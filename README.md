# rss2tw

ask.libreoffice.orgのRSSから最新5分以内のtitle/urlを表示  
crontabで5分毎に実行してtw.plやttytterに繋ぐのを想定

```
$ ./rss2tw.pl
IFTTTによるTwitter自動投稿の試験 http://ask.libreoffice.org/ja/question/68505/iftttniyorutwitterzi-dong-tou-gao-noshi-yan/
$ ./rss2tw.pl | tw
```

# 必要pkg

## Debian stretch

`libwww-perl`
`libxml-rss-perl`
`libdatetime-format-http-perl`
