class MobileController < ApplicationController

  before_filter :check_for_mobile

  def index
    @card_names = ["BRUCE WAYNE", "TONY STARK", "JOHN LOCKE", "INDIANA JONES", "JAMES BOND", "LUKE SKYWALKER"] 
  end

end
