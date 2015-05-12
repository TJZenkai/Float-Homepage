class WelcomeController < ApplicationController

  before_filter :check_for_mobile

  def index
    @card_names = ["BRUCE WAYNE", "TONY STARK", "JOHN LOCKE", "INDIANA JONES", "JAMES BOND", "LUKE SKYWALKER"]
  end

  def faq
    @data = File.read("app/assets/data/faq.json")
    @hash_response = JSON.parse(@data)
  end


  # Privacy Policy
  def privacy
  end
  # Terms of Use
  def terms
  end
  # Support
  def support
  end

end
