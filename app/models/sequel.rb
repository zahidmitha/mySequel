class Sequel < ActiveRecord::Base
  belongs_to :director
  has_and_belongs_to_many :genres

  class << self
    # Three ways of doing this, I've commented out
    # the more verbose ways just to show you what
    # ActiveRecord can do
    def total_by(director)

      # Selecting custom fields, using select and column aliasing
      # This adds the field (in this case count) to the models returned
      # The column is a string so we convert it into an integer
      #
      # select('COUNT(*) AS count').joins(:director).where("directors.name" => director).first.count.to_i

      # Using find by sql to do the whole query in SQL, this is best when doing something too complex
      # for the active record helpers
      # but it is pretty ugly and unwieldy
      #
      # find_by_sql(["SELECT COUNT(*) AS count FROM sequels INNER JOIN directors ON directors.id = sequels.director_id WHERE directors.name = ?", director]).first.count.to_i

      # The neatest way of doing it, but remember this won't work for more complex queries
      joins(:director).where("directors.name" => director).count
    end

    def total_gross

      find_by_sql("SELECT SUM(gross_earnings) FROM sequels")

      # sum("gross_earnings")

    end

    def total_gross_by_year_after(year)
      find_by_sql("SELECT year, gross_earnings FROM sequels WHERE year > ? GROUP BY year", year)

      # select("year, gross_earnings)").where("year > ?", year).group("year")

    end

    def total_by_genre(genre)
      find_by_sql("SELECT COUNT(*) FROM sequels INNER JOIN genres_sequels ON genres_sequels.sequel_id = sequels.id INNER JOIN genres ON genres.id = genres_sequels.genre_id WHERE genres.name = ?", genre)

        # where("genre = ?", genre).count.genres
        # where("genre = ?", genre).count.joins("INNER JOIN genres_sequels ON genres_sequels.sequel_id = sequels.id INNER JOIN genres ON genres.id = genres_sequels.genre_id")

    end

    def average_gross_for(director)
      find_by_sql("SELECT AVG(sequels.gross_earnings) FROM sequels INNER JOIN directors ON directors.id = sequels.director_id WHERE directors.name = ?", director).to_i
    end


    def minimum_made_by(director)
      find_by_sql("SELECT MIN(sequels.gross_earnings) FROM sequels INNER JOIN directors ON directors.id = sequels.director_id WHERE directors.name = ?", director).to_i

    end

    def maximum_gross_before(year)
      find_by_sql("SELECT MAX(gross_earnings) FROM sequels WHERE year < ?", year).to_i
    end

    def highest_grossing_by_genre_and_director(genre, director)
      find_by_sql("SELECT MAX(sequels.gross_earnings) FROM sequels INNER JOIN directors ON directors.id = sequels.director_id INNER JOIN genres_sequels ON genres_sequels.sequel_id = sequels.id INNER JOIN genres ON genres.id = genres_sequels.genre_id WHERE genres.name = ? AND directors.name = ?", genre, director).to_i

    end

  end

end
