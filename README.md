# rspec-ftp-sample

## なにこれ

FTP ユーザーの以下のような振る舞いについて rspec を使ってテストします.   

* ログインできること
* chroot で設定されていること
* ファイルを作成できること
* ファイルを削除できること

## 使い方

1. bundle install を実行して関連するパッケージを導入する
2. secret.yml に FTP サーバーとユーザー名, パスワードを設定する
3. rake コマンドを実行する

## Rake Tasks

```sh
$ bundle exec rake -T
rake ftpcheck:127.0.0.1:user1        # Run ftpcheck to 127.0.0.1 by user1
rake ftpcheck:xxx.xxx.xxx.xxx:user1  # Run ftpcheck to xxx.xxx.xxx.xxx by user1
rake ftpcheck:xxx.xxx.xxx.xxx:user2  # Run ftpcheck to xxx.xxx.xxx.xxx by user2
```

## 設定

### secret.yml

```yaml
xxx.xxx.xxx.xxx:
  users:
    - username: user1
      password: password1
    - username: user2
      password: password2
127.0.0.1:
  users:
    - username: user1
      password: password1
```

## 実行例

```sh
$ bundle exec rake ftpcheck:xxx.xxx.xxx.xxx:user1

#be_accessible (real server)
  can login valid user and password

#be_chroot (real server)
  check chroot enabled

#be_writable (real server)
  check writable with active mode
  check not writable with passive mode

#be_removable (real server)
  check removable

Finished in 2.23 seconds (files took 0.21187 seconds to load)
5 examples, 0 failures
```
