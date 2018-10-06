# rspec-ftp-sample
[![Build Status](https://travis-ci.org/inokappa/rspec-ftp-sample.svg?branch=master)](https://travis-ci.org/inokappa/rspec-ftp-sample)
## なにこれ

FTP ユーザーの以下のような振る舞いについて rspec を使ってテストします.   

* ログインできること
* chroot で設定されていること
* ファイルを作成できること (実際に FTP サーバー上にテストファイルを設置してテストする)
* ファイルを削除できること (実際に FTP サーバー上にテストファイルを設置してテストする)

## 必要なもの

* Docker
* docker-compose

## 使い方

1. `docker-compose up -d` を実行して環境を構築する (いくつかの Ruby バージョンのコンテナと vsftpd サーバーが起動します)
2. secret.yml に FTP サーバーとユーザー名, パスワードを設定する
3. docker-compose exec bundle exec ... コマンドを実行してテスト対象を確認, テストを実行する

## コンテナ一覧

`docker-compose up -d` を実行すると以下のようなコンテナが起動する.

```sh
$ docker-compose ps
    Name                   Command               State                                                                                           Ports
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rspec-ruby23    tail -f /dev/null                Up
rspec-ruby24    tail -f /dev/null                Up
rspec-ruby25    tail -f /dev/null                Up
vsftpd-server   /bin/sh -c /usr/sbin/entry ...   Up      0.0.0.0:21->21/tcp, 0.0.0.0:21200->21200/tcp, 0.0.0.0:21201->21201/tcp, 0.0.0.0:21202->21202/tcp, 0.0.0.0:21203->21203/tcp, 0.0.0.0:21204->21204/tcp, 0.0.0.0:21205->21205/tcp,
                                                         0.0.0.0:21206->21206/tcp, 0.0.0.0:21207->21207/tcp, 0.0.0.0:21208->21208/tcp, 0.0.0.0:21209->21209/tcp, 0.0.0.0:21210->21210/tcp
```

## secret.yml

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

## Rake Tasks

以下は Ruby 2.5 環境でテストする場合.

```sh
$ docker-compose exec rspec-ruby25 bundle exec rake -T
rake ftpcheck:127.0.0.1:user1        # Run ftpcheck to 127.0.0.1 by user1
rake ftpcheck:xxx.xxx.xxx.xxx:user1  # Run ftpcheck to xxx.xxx.xxx.xxx by u...
rake ftpcheck:xxx.xxx.xxx.xxx:user2  # Run ftpcheck to xxx.xxx.xxx.xxx by u...
```

## 実行例

```sh
$ docker-compose exec rspec-ruby25 bundle update
$ docker-compose exec rspec-ruby25 bundle exec rake ftpcheck:vsftpd-server:ftpuser
/usr/local/bin/ruby -I/usr/local/bundle/gems/rspec-core-3.8.0/lib:/usr/local/bundle/gems/rspec-support-3.8.0/lib /usr/local/bundle/gems/rspec-core-3.8.0/exe/rspec spec/ftp_spec.rb

#be_accessible (real server)
  can login valid user and password

#be_chroot (real server)
  check chroot enabled

#be_writable (real server)
  check writable with active mode
  check writable with active mode and use original test file

#be_removable (real server)
  check removable
  check removable with passive mode and use original test file

Finished in 0.14608 seconds (files took 0.18224 seconds to load)
6 examples, 0 failures

# Summary by Type or Subfolder

| Type or Subfolder  | Example count | Duration (s) | Average per example (s) |
|--------------------|---------------|--------------|-------------------------|
| ./spec/ftp_spec.rb | 6             | 0.1386       | 0.0231                  |


# Summary by File

| File               | Example count | Duration (s) | Average per example (s) |
|--------------------|---------------|--------------|-------------------------|
| ./spec/ftp_spec.rb | 6             | 0.1386       | 0.0231                  |
```

## テストコードサンプル

```ruby
require 'spec_helper'

describe '#be_accessible (real server)' do
  it 'can login valid user and password' do
    expect(ENV['TARGET_HOST']).to be_accessible.user(property['username']).pass(property['password'])
  end
end

describe '#be_chroot (real server)' do
  it 'check chroot enabled' do
    expect(ENV['TARGET_HOST']).to be_chroot.user(property['username']).pass(property['password'])
  end
end

describe '#be_writable (real server)' do
  # rspec-ftp_${ランダム文字列}.txt というファイルを FTP サーバー上に作成, 削除します
  it 'check writable with active mode' do
    expect(ENV['TARGET_HOST']).to be_writable.user(property['username']).pass(property['password']).passive
  end

  # rspec-ftp_foobar.txt というファイルを FTP サーバー上に作成, 削除します
  it 'check writable with active mode and use original test file' do
    expect(ENV['TARGET_HOST']).to be_writable.user(property['username']).pass(property['password']).passive.test_filename('foobar')
  end
end

describe '#be_removable (real server)' do
  # rspec-ftp_${ランダム文字列}.txt というファイルを FTP サーバー上に作成, 削除します
  it 'check removable' do
    expect(ENV['TARGET_HOST']).to be_removable.user(property['username']).pass(property['password']).passive
  end

  # rspec-ftp_foobar.txt というファイルを FTP サーバー上に作成, 削除します
  it 'check removable with passive mode and use original test file' do
    expect(ENV['TARGET_HOST']).to be_removable.user(property['username']).pass(property['password']).passive.test_filename('foobar')
  end
end
```