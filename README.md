# rss2tw

引数に指定したRSSから指定秒以内のtitle/urlを表示  
指定秒が0の場合全てのエントリ分を表示  
crontabで定期的に実行してtw.plやttytterに繋ぐのを想定

```
$ ./rss2tw.pl http://matoken.org/blog/feed/rss/ 999999
"Bash on Ubuntu on Windows(Windows Subsystem for linux)を少し試す" http://matoken.org/blog/blog/2016/04/14/try-bash-on-ubuntu-on-windowswindows-subsystem-for-linux/
$ ./rss2tw.pl | tw
```

# 必要pkg

## Debian stretch

`libwww-perl`
`libxml-rss-perl`
`libdatetime-format-http-perl`

