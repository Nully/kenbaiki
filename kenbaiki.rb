# encoding: utf-8

require "pry"

class Kenbaiki

  # 投入可能なお金一覧
  ALLOW_MONYE_TYPES = {
    10   => "10円",
    50   => "50円",
    100  => "100円",
    500  => "500円",
    1000 => "1000円"
  }.freeze

  # 購入できるチケット一覧
  TICKETS = {
    200 =>"200円",
    250 => "250円",
    300 => "300円",
  }.freeze

  class << self
    def init
      # 投入金額の合計
      @@investment_total = 0
      @@total_amount = 0
    end

    def format amount
      "#{amount} 円"
    end

    # 投入金額の出力
    def total
      format @@investment_total
    end

    # 売上の表示
    def amount
      format @@total_amount
    end

    def add_money money
      return "#{money}円は許可されていないお金です。" unless accept_money?(money)
      @@investment_total += money
    end

    # 払い戻す
    def pay_back
      msg = "釣り銭 : #{self.total}"
      @@investment_total = 0
      msg
    end

    # チケットを購入する
    def buy_ticket money
      return "券は#{Kenbaiki::TICKETS.values.join(" ")}のみ購入できます。" if !accept_ticket?(money)
      return "投入金額が#{money - @@investment_total} 円不足しています。" if available_purchase?(money)

      @@investment_total -= money
      @@total_amount += money
      puts "#{Kenbaiki::TICKETS[money]}の券を購入しました。"
      puts self.pay_back
    end

    def accept_money? amount
      self::ALLOW_MONYE_TYPES.keys.include?(amount)
    end

    def accept_ticket? money
      self::TICKETS.keys.include?(money)
    end

    def available_purchase? money
      money > @@investment_total
    end
  end

end

Kenbaiki.init

Pry.commands.block_command "help" do
  output.puts "monies : 投入できるお金の一覧を出力します。"
  output.puts "add [money...] : お金を券売機に投入します。投入できるお金の一覧は「monies」で確認できます。"
  output.puts "payback : 投入されたお金を払い戻します。"
  output.puts "buy [#{Kenbaiki::TICKETS.keys.join('|')}] : チケットを購入します。"
  output.puts "total : 現在投入されている金額を表示します。"
  output.puts "amount : 現在の売上を表示します。"
end

# 投入できるお金の一覧を出力
Pry.commands.block_command "monies" do
  output.puts "投入できる金額の一覧:"
  Kenbaiki::ALLOW_MONYE_TYPES.each do |k, v|
    output.puts "#{k} => #{v}"
  end
end

# お金を投入
Pry.commands.block_command "add" do |*args|
  output.puts Kenbaiki.add_money(args.first.to_i)
  output.puts "投入金額 : #{Kenbaiki.total}"
end

Pry.commands.block_command "payback" do
  output.puts "すべての投入金額を払い戻します。"
  output.puts Kenbaiki.pay_back
end

# 投入金額を出力
Pry.commands.block_command "total" do
  output.puts "投入金額 : #{Kenbaiki.total}"
end

# 購入
Pry.commands.block_command "buy" do |*args|
  output.puts Kenbaiki.buy_ticket(args.first.to_i)
end

# 売上の表示
Pry.commands.block_command "amount" do
  output.puts Kenbaiki.amount
end

Pry.prompt = [
  proc{"Kenbaiki> "},
  proc{"Kenbaiki* "}
]

Pry.run_command "help"
puts ""

pry
