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

    def match_fixing(cards, players)
        num_of_players = players.length
        max_loop_count = cards.card_collection.length - 1
        for i in 0..max_loop_count
            if cards.card_collection[0].strength > 5
                players[0].hand << cards.card_collection.delete_at(0)
            else
                players[1].hand << cards.card_collection.delete_at(0)
            end
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
            return '', true
        else
            return players[@compare_hash.key(max_value)], false
        end
    end

    def put_card(player)
        # 手札の山札の一番上、要するに配列の一番最後
        puts "#{player.name}のカードは#{player.hand[-1].name}です。"
    end

    def get_cards(winner)
        winner.added_hand += @pool_cards
        @pool_cards = []
    end

    def check_do_rematch(players)
        players.each do | player |
            if player.hand.length == 0
                if player.added_hand.length == 0
                    return player, false
                else
                    player.hand += player.added_hand.shuffle!
                    player.added_hand = []
                end
            end
        end
        return '', true
    end

end

class Player
    attr_accessor :hand, :added_hand
    attr_reader :name, :num_of_total_hands
    def initialize(name)
        @name = name
        @hand = []
        @added_hand = []
        @num_of_total_hands = 0
    end

    def calculate_total_hands()
        @num_of_total_hands = @hand.length + @added_hand.length
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

participants = []

is_draw = false
is_rematch = true

performance_ranking = Hash.new(0)

puts "戦争を開始します。"

while true
    print "プレイヤーの人数を入力してください（2〜5）: "
    num_of_players = gets.to_i
    if 2 <= num_of_players && num_of_players <= 5
        break
    else
        puts "人数は2~5で再度入力してください。"
    end
end


for i in 1..num_of_players
    print "プレイヤー#{i}の名前を入力してください: "
    participants << gets.chomp
end

cards = Cards.new
players = participants.map do | participant |
    Player.new(participant)
end

game = Game.new()
game.distribute_cards(cards, players)
# game.match_fixing(cards, players)

puts "カードが配られました。"

while true
    if is_rematch
        puts "戦争！"
        winner, is_draw = game.war(players)
        if is_draw
            puts "引き分けです。"
        else
            puts "#{winner.name}が勝ちました。#{winner.name}はカードを#{game.pool_cards.length}枚もらいました。"
            game.get_cards(winner)
        end
    else
        break
    end
    game_loser, is_rematch = game.check_do_rematch(players)
end

puts "#{game_loser.name}の手札がなくなりました。"

players.each do |player|
    player.calculate_total_hands()
    print "#{player.name}の手札の枚数は#{player.num_of_total_hands}枚です。"
end

print "\n"

players.sort_by { |player| player.num_of_total_hands }.reverse.each_with_index do |player, index|
    print "#{player.name}が#{index+1}位"
    if not index == players.size-1
        print "、"
    else
        print "です。\n"
    end
end

puts "戦争を終了します。"