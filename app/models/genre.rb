class Genre < ActiveRecord::Base
  has_and_belongs_to_many :sequels

  class << self

    def with_more_than_one_film
      
      # find_by_sql("SELECT * FROM genres INNER JOIN genres_sequels ON genres_sequels.genre_id = genres.id INNER JOIN sequels ON genres_sequels.sequel_id = sequels.id GROUP BY genre.name HAVING COUNT(genre.name) > 1")
    end

    def earned_more_than(number)
      
      # find_by_sql("SELECT genres.name, sequels.gross_earnings FROM genres INNER JOIN genres_sequels ON genres_sequels.genre_id = genres.id INNER JOIN sequels ON genres_sequels.sequel_id = sequels.id GROUP BY genres.name HAVING sequels.gross_earnings > ?", number)

    end


  end
end