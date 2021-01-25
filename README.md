# Ec2craft

個人でAWS EC2上にminecraftサーバを運営する際に役立つDiscord Botです。

- Discordのtext channelでコマンドを入力することで，EC2インスタンスの起動・停止を行うことができます。
- サーバ停止時，突然シャットダウンするのではなく，minecraftサービス停止と `shutdown` コマンドによる停止が可能です。

## Install

```
$ git clone https://github.com/highemerly/ec2craft/
$ cd ec2craft/
$ bundle install
$ cp .env.template .env
$ vi .env
  # 各種設定変数を適切に設定する
$ ruby ec2craft.rb
```

## 詳細

このbotの大半の実装はRubygemsの Ec2Discord に依存します。詳細は https://github.com/highemerly/ec2discord/ も参照ください。