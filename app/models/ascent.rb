require "csv"

class Ascent < ActiveRecord::Base

  belongs_to :user
  belongs_to :hill
  
  validates :user_id, presence: true
  validates :hill_id, presence: true

end
