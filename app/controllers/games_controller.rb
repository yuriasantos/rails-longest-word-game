# frozen_string_literal: true

require 'open-uri'
require 'json'
require 'date'

# Controller to play the game.
class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
  end

  def score
    @attempt = params['attempt']
    @letters = params['grid'].gsub(' ', ', ')
    @is_in_grid = in_grid?(params['grid'].split(' '), @attempt)
    @is_in_dict = in_dict?(@attempt)
  end

  private

  def in_grid?(grid, attempt)
    check = true
    attempt.upcase.chars.each do |char|
      if grid.include?(char)
        check &&= true
        grid.delete_at(grid.index(char))
      else
        check &&= false
      end
    end

    check
  end

  def generate_grid(grid_size)
    alphabet = ('A'..'Z').to_a
    grid = []
    while grid_size.positive?
      grid << alphabet.sample
      grid_size -= 1
    end

    grid
  end

  def in_dict?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt.downcase}"
    word_serialized = URI.open(url).read
    word = JSON.parse(word_serialized)

    word['found']
  end
end



# <%# def run_game(attempt, grid, start_time, end_time)
#   duration = end_time - start_time

#   return { score: 0, message: "not in the grid", time: duration } unless in_grid?(grid, attempt)

#   url = "https://wagon-dictionary.herokuapp.com/#{attempt.downcase}"
#   word_serialized = URI.open(url).read
#   word = JSON.parse(word_serialized)

#   return { score: 0, message: "not an english word", time: duration } unless word["found"]

#   return { score: word.length.to_f + (1 / duration), message: "well done", time: duration }
# end %>
