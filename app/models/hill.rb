require "csv"

class Hill < ActiveRecord::Base

  has_many :ascents, dependent: :destroy
  has_many :users, through: :ascents, source: :user

	def self.import(file)
  		CSV.foreach(file.path, headers: true) do |row|
  			Hill.create! row.to_hash
  		end
	end

  def self.get_pattern(hill_category)
  	if hill_category == 'Munros'
      'M...'
    elsif hill_category == 'Munro Tops'
      'MT...'
    elsif hill_category  == 'Corbetts'
      'C...'
    elsif hill_category == 'Grahams'
      'G...'
    end
  end

  def self.get_category(hill_number)
    if hill_number.match('MT...')
      'Munro Tops'
    elsif hill_number.match('M...')
      'Munros'
    elsif hill_number.match('C...')
      'Corbetts'
    elsif hill_number.match('G...')
      'Grahams'
    end
  end

end
