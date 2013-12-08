class Genre < ActiveRecord::Base
  has_and_belongs_to_many :sequels

  class << self

    def with_more_than_one_film
      
    	joins(:sequels)
      .group("genres.name")
      .having("COUNT(*) > 1")
      .order("genres.name ASC")
      .count
      .keys

      # I don't really understand how this works

       # SELECT COUNT(*) AS cnt FROM genres INNER JOIN genres_sequels ON genres_sequels.genre_id = genres.id INNER JOIN sequels ON genres_sequels.sequel_id = sequels.id GROUP BY genres.name HAVING COUNT(*) > 1;


      # Genre.find_by_sql("SELECT COUNT(*) AS cnt FROM genres INNER JOIN genres_sequels ON genres_sequels.genre_id = genres.id INNER JOIN sequels ON genres_sequels.sequel_id = sequels.id GROUP BY genre.name HAVING cnt > 1")
    end

    def earned_more_than(number)
      	
      joins(:sequels)
      .group("genres.name")
      .having("SUM(gross_earnings) > ?", number)
      .sum("gross_earnings")



      # find_by_sql("SELECT genres.name, sequels.gross_earnings FROM genres INNER JOIN genres_sequels ON genres_sequels.genre_id = genres.id INNER JOIN sequels ON genres_sequels.sequel_id = sequels.id GROUP BY genres.name HAVING sequels.gross_earnings > ?", number)

    end


  end
end