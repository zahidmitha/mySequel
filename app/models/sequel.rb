class Sequel < ActiveRecord::Base
  belongs_to :director
  has_and_belongs_to_many :genres
end