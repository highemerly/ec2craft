require 'dotenv'
require 'ec2discord'

class Ec2craftbot < Ec2discord::Bot
  def initialize
    read_env
    super
  end

  def read_env
    if ARGV[0] == nil then
      Dotenv.load ".env"
      $log.info("Reading .env ...")
      puts "Readming .env ..."
    else
      if File.exist?(ARGV[0]) then
        Dotenv.load ARGV[0]
        $log.info("Reading #{ARGV[0].to_s} ...")
        puts "Reading #{ARGV[0].to_s} ..."
      else
        $log.fatal("Cannot open #{ARGV[0].to_s}. Existed.")
        puts "Cannot open #{ARGV[0].to_s}. Existed."
        exit
      end
    end
  end

  def setup
    super
    @msg_help["nanisuru"] = "なにをすべきか教えてくれます。"
    @bot.command :nanisuru do |event|
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
      pp event.user
      event.user.name + "さんは" + t[r]
    end

    @msg_help["info"] = "サーバ情報を出力します。"
    @bot.command :info do |event|
      msg  = "```\n"
      msg += "接続先: minecraft.handon.club\n"
      msg +- "       ipv6.minecraft.handon.club (IPv6のみ)\n"
      msg += "バージョン: Java版 1.15.2\n"
      msg += "必須MOD: なし（バニラ）\n"
      msg += "マップ: https://map.minecraft.handon.club/\n"
      msg += "ソースコード: https://github.com/highemerly/ec2craft\n"
      msg += "ルール: 特になし，ご自由に遊んでください\n"
      msg += "```\n"
    end
  end
end

bot = Ec2craftbot.new
bot.run