require 'dotenv'
require 'ec2discord'

MINECRAFT_VERSION="Java版 1.16.4"
MINECRAFT_SERVER="minecraft.handon.club"
MINECRAFT_MAP="https://minecraft-map.handon.club/"

class Ec2craftbot < Ec2discord::Bot
  def setup
    super

    @msg_help["minecraft"] = "マイクラアプリに関連する制御要求，または状態確認を行います。"
    @bot.command :minecraft do |event, cmd|
      setup_minecraft(event, cmd)
    end

    @msg_help["info"] = "情報を一覧で表示します。"
    @bot.command :info do |event|
      setup_info(event)
    end
  end

  def sh_minecraft_reload
    @sh_ssh + hostname + " sudo systemctl reload " + ENV["SV_SERVICENAME"]
  end

  def sh_minecraft_start
    @sh_ssh + hostname + " sudo systemctl start " + ENV["SV_SERVICENAME"]
  end

  def setup_minecraft(event, cmd)
    case cmd
    when "reload" then
      @last_control_time = Time.now.to_i
      event.respond("アプリの再起動を要求します。起動までお待ちください。")
      stdout, stderr = Open3.capture3(sh_minecraft_reload)
      if stderr.include?("timed") then
        event.respond("サーバが起動していません")
      end
    when "start" then
      @last_control_time = Time.now.to_i
      stdout, stderr = Open3.capture3(sh_minecraft_start)
      if stderr.include?("timed") then
        event.respond("サーバが起動していません")
      end
      event.respond("アプリの起動を要求しました。")
    when "nanisuru" then
      t = Array[
        "ダイヤを掘りにいく",
        "畑に植える",
        "畑を収穫する",
        "新たな廃坑をさがしに行く",
        "村をさがしに行く",
        "遠くに旅に出かける",
        "洞窟探検に出かける",
        "海底神殿に行く",
        "新しい建築をする",
        "わきつぶしをする",
        "村人と交易する",
        "原木を取りに行く",
        "植林する",
        "マグマダイブする",
        "エンチャントをする",
        "馬に乗る",
        "整地する",
        "寝る",
        "釣りをする",
        "何かを破壊する",
        "整地する",
        "家畜を育てる",
        "家畜を殺して食料を入手する",
        "料理をする",
        "ネザーを探検する",
        "エンドに行く",
        "珍しい作物を探しに行く",
        "鉄道に乗って旅をする",
        "直下堀りをする",
        "ブランチマイニングをする"
      ]
      r = rand(0..t.size-1)
      event.user.name + "さんは" + t[r]
    when "info" then
      setup_info(event)
    else
      msg  = ""
      unless cmd == "help" || cmd == nil then
        msg += "存在しないコマンドです。"
      end
      msg += "```\n"
      msg += @prefix + "minecraft [command]\n"
      msg += "       " + @msg_help["minecraft"] + "\n"
      msg += "\n"
      msg += " [command]\n"
      msg += "   start.....アプリデーモンを起動します。\n"
      msg += "   reload....アプリデーモンを再起動します。\n"
      msg += "   info......サーバに関する情報を出力します。\n"
      msg += "   nanisuru..何をすべきか教えてくれます。\n"
      msg += "   help......このメッセージを表示します。\n"
      msg += "```\n"
    end
  end

  def setup_info(event)
    event.send_embed do |embed|
      embed.title = "はんドンマイクラ鯖"
      embed.description = "誰でも参加できるマインクラフトサーバーです。"
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: 'https://media.handon.club/media_attachments/files/105/562/970/656/379/340/original/6bd9e58f7be47ec4.png')
      embed.add_field(
        name: "接続先",
        value: "#{MINECRAFT_SERVER}",
        inline: false,
      )
      embed.add_field(
        name: "接続先(予備：上記で繋がらない場合)",
        value: "#{hostname}",
        inline: false,
      )
      embed.add_field(
        name: "バージョン",
        value: "#{MINECRAFT_VERSION}",
        inline: true,
      )
      embed.add_field(
        name: "必須MOD",
        value: "なし",
        inline: true,
      )
      embed.add_field(
        name: "マップ",
        value: "#{MINECRAFT_MAP}",
        inline: false,
      )
    end
  end
end

bot = Ec2craftbot.new
bot.run