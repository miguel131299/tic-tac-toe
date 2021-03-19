class String
  def is_integer?
    to_i.to_s == self
  end
end

class Player
  MESS = 'SYSTEM ERROR: method missing'

  attr_reader :name, :symbol, :gameboard

  def initialize(name, symbol, gameboard = nil)
    @name = name
    @symbol = symbol
    @gameboard = gameboard
  end

  def play_round
    raise MESS
  end

  def setGameboard(gameboard)
    @gameboard = gameboard
  end
end

class HumanPlayer < Player
  def initialize(name, symbol, gameboard = nil)
    super(name, symbol, gameboard)
  end

  def play_round
    input = nil

    # do while to place piece
    loop do

      # do while loop to get input
      loop do
        puts("#{@name}! Which position do you want to play?")
        input = gets.chomp

        break if input.is_integer? && input.to_i >= 1 && input.to_i <= 9
      end

      position = input.to_i

      break if gameboard.place_symbol(self, position)
    end
  end
end

class ComputerPlayer < Player
  def initialize(name, symbol, gameboard = nil)
    super
  end

  # TODO: play_round method
  def play_round
      loop do
        choice = rand(1..9)

        #break if valid
        break if @gameboard.place_symbol(self, choice)
      end
  end
end

class Gameboard
  attr_reader :board

  def initialize(player1, player2)
    @board = Array.new(10) { |index| index }
    @player1 = player1
    @player2 = player2

    player1.setGameboard(self)
    player2.setGameboard(self)
  end

  def print_board
    # ignore the index 0

    puts "#{@board[1]} | #{@board[2]} | #{@board[3]}\n" +
         "--+---+--\n" +
         "#{@board[4]} | #{@board[5]} | #{@board[6]}\n" +
         "--+---+--\n" +
         "#{@board[7]} | #{@board[8]} | #{@board[9]}\n\n"
  end

  # takes in a player and a position between 1 and 9 as parameters
  # returns false if position occupied
  def place_symbol(player, position)
    # position occupied
    if @board[position] != position
      puts "Position #{position} has already been used"
      return false
    end

    @board[position] = player.symbol
    true
  end

  def game_ended?
    game_won?(@player1) || game_won?(@player2) || board_full?
  end

  def game_won?(player)
    # horizontal
    if @board[1] == player.symbol && @board[2] == player.symbol && @board[3] == player.symbol
      true

    elsif @board[4] == player.symbol && @board[5] == player.symbol && @board[6] == player.symbol
      true

    elsif @board[7] == player.symbol && @board[8] == player.symbol && @board[9] == player.symbol
      true

    # vertical
    elsif @board[1] == player.symbol && @board[4] == player.symbol && @board[7] == player.symbol
      true

    elsif @board[2] == player.symbol && @board[5] == player.symbol && @board[8] == player.symbol
      true

    elsif @board[3] == player.symbol && @board[6] == player.symbol && @board[9] == player.symbol
      true

    # diagonal
    elsif @board[1] == player.symbol && @board[5] == player.symbol && @board[9] == player.symbol
      true

    else
      false
    end
  end

  def board_full?
    #check if there is an integer left
    @board.none? {|position| position.class == Integer}
  end

  def play_game
    current_player = @player1
    while !(game_ended?)
        
        print_board
        current_player.play_round

        if current_player == @player1
            current_player = @player2
        else
            current_player = @player1
        end
    end
  end
end

# main method
def run_game
  puts "Welcome to Tic-Tac-Toe!\n"

  loop do
    puts "If you want to play against a computer, enter '1'.\n" +
            "If you want to play against another human, enter '2'"

    input = gets.chomp

    if input == '1'
      game_with_computer
    elsif input == '2'
      game_with_human
    end
  end
end

def game_with_human

    player1 = get_user_info(1)
    player2 = get_user_info(2)

    gameboard = Gameboard.new(player1,player2)

    gameboard.play_game

    if gameboard.game_won?(player1)
        print_winner_message(player1)
    elsif 
        print_winner_message(player2)
    else
        print_tied_message()
    end

end

def game_with_computer

    player1 = get_user_info(1)
    player2 = ComputerPlayer.new("Computer", "X")
    gameboard = Gameboard.new(player1, player2)

    gameboard.play_game

    p gameboard.game_won?(player1)

    if gameboard.game_won?(player1)
        print_winner_message(player1)
    elsif 
        print_lost_against_computer()
    else
        print_tied_message()
    end
end

def play_game(player1, player2)
    
end

def get_user_info(playerNumber)
    puts "Player #{playerNumber}! What is your name?"
    name = gets.chomp
    symbol = nil
  
    # do while to get valid symbol
    loop do
      puts "#{name}! What symbol do you want to use? (It can't be a number)"
      symbol = gets.chomp
  
      if symbol.length == 1 && !symbol.is_integer?
        break
      else
        puts 'Invalid Symbol!'
      end
    end
  
    HumanPlayer.new(name, symbol)
end

def print_winner_message(player)
    puts "Congratulations #{player.name}! You have won the game."
end

def print_lost_against_computer
    puts "Looks like you could not beat the Computer"
end

def print_tied_message
    puts "It looks like it is a tie!"
end



# player1 = HumanPlayer.new('Miguel', '@')
# player2 = HumanPlayer.new('Ana', 'O')
# gameboard = Gameboard.new(player1, player2)
# gameboard.print_board

# board = gameboard.board

# # board[1] = player1.symbol
# # board[5] = player1.symbol
# # board[9] = player1.symbol

# # puts gameboard.game_won?(player1)

# # puts gameboard.place_symbol(player1, 1)
# # gameboard.print_board

# player1.play_round
# gameboard.print_board

run_game