class Sequel < ActiveRecord::Base
  belongs_to :director
  has_and_belongs_to_many :genres

  # Three ways of doing this, I've commented out
  # the more verbose ways just to show you what
  # ActiveRecord can do
  def self.total_by(director)

    # Selecting custom fields, using select and column aliasing
    # This adds the field (in this case count) to the models returned
    # The column is a string so we convert it into an integer
    #
    # select('COUNT(*) AS count').joins(:director).where("directors.name" => director).first.count.to_i

    # Using find by sql to do the whole query in SQL, this is best when doing something too complex
    # for the active record helpers
    # but it is pretty ugly and unwieldy
    #
    # find_by_sql("SELECT COUNT(*) AS count FROM sequels INNER JOIN directors ON directors.id = sequels.director_id WHERE directors.name = '#{director}'").first.count.to_i

    # The neatest way of doing it, but remember this won't work for more complex queries
    joins(:director).where("directors.name" => director).count
  end
end