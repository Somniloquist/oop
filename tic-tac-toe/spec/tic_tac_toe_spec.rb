require "./lib/tic_tac_toe.rb"

describe TicTacToe do

  describe "#player_wins?" do
    it "returns true if player wins horizonal victory" do
      game = TicTacToe::Game.new
      game.board[1] = [1,1,1]
      last_move = [1,1]
      expect(game.send(:player_wins?, last_move)).to eql(true)
    end
    it "returns true if player wins vertical victory" do
      game = TicTacToe::Game.new
      game.board[0][1], game.board[1][1], game.board[2][1] = 1,1,1
      last_move = [1,1]
      expect(game.send(:player_wins?, last_move)).to eql(true)
    end
    it "returns true if player wins diagonal victory" do
      game = TicTacToe::Game.new
      game.board[0][0], game.board[1][1], game.board[2][2] = 1,1,1
      last_move = [1,1]
      expect(game.send(:player_wins?, last_move)).to eql(true)
    end
  end

  describe "#space_available?" do
    game = TicTacToe::Game.new
    game.board = [[1,1,1],[1,0,1],[1,1,1]]

    it "returns true if space on the board is available" do
      expect(game.send(:space_available?, 1,1)).to eql(true)
    end
    it "returns nil if space on the board is not available" do
      expect(game.send(:space_available?, 0,0)).to eql(false)
    end
  end

  describe "#place_marker" do
    it "places marker at location" do
      game = TicTacToe::Game.new
      expect(game.board[0][0]).to eql(0)
      game.send(:place_marker, 1, [0,0])
      expect(game.board[0][0]).to eql(1)
    end
  end
  
end