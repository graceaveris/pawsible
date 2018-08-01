class ChallengesController < ApplicationController
  def index
    @challenges = Challenge.all.order(:created_at).reverse_order.limit(6)
  end
end