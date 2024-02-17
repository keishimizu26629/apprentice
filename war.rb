# encoding: UTF-8
class Game
    attr_reader :pool_cards
    def initialize()
        @compare_hash = Hash.new(0)
        @pool_cards = []
    end
    def distribute_cards(cards, players)
        num_of_players = players.length
        max_loop_count = cards.card_collection.length - 1
        for i in 0..max_loop_count
            players[i % num_of_players].hand << cards.card_collection.delete_at(0)
        end
    end

    def war(players)
        @compare_hash = {}
        players.each_with_index do | player, index |
            put_card(player)
            @compare_hash[index] = player.hand[-1].strength
            @pool_cards << player.hand.delete_at(-1)
        end
        max_value = @compare_hash.values.max
        if @compare_hash.count{| key, value | value == max_value} > 1
            return '', false
        else
            return players[@compare_hash.key(max_value)], true
        end
    end

    def put_card(player)
        # 手札の山札の一番上、要するに配列の一番最後
        puts "#{player.name}のカードは#{player.hand[-1].name}です。"
    end

    def get_cards(winner)
        winner.added_hand << @pool_cards
        @pool_cards = []
    end
end

class Player
    attr_accessor :hand, :added_hand
    attr_reader :name
    def initialize(name)
        @name = name
        @hand = []
        @added_hand = []
    end
end

class Card
    attr_reader :name, :mark, :rank, :strength
    def initialize(mark, rank, strength, name)
        @name = name
        @mark = mark
        @rank = rank
        @strength = strength
    end
end

class Cards

    attr_accessor :card_collection
    MARKS = ['ハート', 'ダイヤ', 'クラブ', 'スペード']
    RANKS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
    # RANKS = ['2', '3', '4']
    STRENGTHS = (1..13).to_a
    # STRENGTHS = (1..3).to_a
    def initialize()
        @card_collection = []
        self.set_card_collection()
        @card_collection.shuffle!
    end

    def set_card_collection()
        MARKS.each do | mark |
            RANKS.each_with_index do | rank, index |
                @card_collection << Card.new(mark, rank, STRENGTHS[index], "#{mark}の#{rank}")
            end
        end
    end
end

participants = ['プレイヤー1', 'プレイヤー2']
break_flag = false

cards = Cards.new
players = participants.map do | participant |
    Player.new(participant)
end

puts "戦争を開始します。"

game = Game.new()
game.distribute_cards(cards, players)

puts "カードが配られました。"

while true
    puts "戦争！"
    winner, break_flag = game.war(players)
    if break_flag
        puts "#{winner.name}が勝ちました。#{winner.name}はカードを#{game.pool_cards.length}枚もらいました。"
            game.get_cards(winner)
        break
    else
        puts "引き分けです。"
    end
end

puts "戦争を終了します。"
