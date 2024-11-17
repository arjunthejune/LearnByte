class CardsController < ApplicationController
  before_action :setup_deck

  # POST /cards/1
  def new
  end

  # DELETE /cards/1
  def destroy
  end

  private
    # Initializes an empty deck with a single empty card
    def setup_deck
      @deck = Deck.new(cards: [ Card.new ])
    end
end
