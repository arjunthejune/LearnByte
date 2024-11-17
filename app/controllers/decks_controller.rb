require "net/http"

class DecksController < ApplicationController
  before_action :set_deck, only: %i[ show edit update destroy ]

  # GET /decks or /decks.json
  def index
    @decks = Deck.all
  end

  # GET /decks/generator
  def generator

  end

  # GET /decks/1 or /decks/1.json
  def show
  end

  # GET /decks/new
  def new
    # Initializes an empty deck with a single empty card
    @deck = Deck.new(cards: [ Card.new ])
  end

  # POST /decks/generate
  def generate
    @deck = Deck.new

    uri = URI.parse("http://localhost:5000/getCards")
    data = "{\"userInput\":\"#{params[:topic]}\"}"
    headers = { "content-type": "application/json" }
    response = Net::HTTP.post uri, data, headers

    jsonObject = JSON.parse(response.body)

    unless jsonObject["title"].nil?
      @deck.title = jsonObject["title"]
    end
    unless jsonObject["cards"].nil?
      jsonObject["cards"].each do |hash|
        @deck.cards.append Card.new(term: hash["term"], definition: hash["definition"])
      end
    end

    if @deck.save
      redirect_to @deck
    else
      render :new, status: :unprocessable_content
    end
  end

  # GET /decks/1/edit
  def edit
  end

  # POST /decks or /decks.json
  def create
    @deck = Deck.new(deck_params)

    respond_to do |format|
      if @deck.save
        format.html { redirect_to @deck, notice: "Deck was successfully created." }
        format.json { render :show, status: :created, location: @deck }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @deck.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /decks/1 or /decks/1.json
  def update
    respond_to do |format|
      if @deck.update(deck_params)
        format.html { redirect_to @deck, notice: "Deck was successfully updated." }
        format.json { render :show, status: :ok, location: @deck }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @deck.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /decks/1 or /decks/1.json
  def destroy
    @deck.destroy!

    respond_to do |format|
      format.html { redirect_to decks_path, status: :see_other, notice: "Deck was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deck
      @deck = Deck.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def deck_params
      params.require(:deck).permit(:title, :description, cards_attributes: [ :term, :definition ])
    end
end
