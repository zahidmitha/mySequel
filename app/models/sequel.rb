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
      find_by_sql(["SELECT COUNT(*) AS count FROM sequels INNER JOIN directors ON directors.id = sequels.director_id WHERE directors.name = ?", director]).first.count.to_i

      # The neatest way of doing it, but remember this won't work for more complex queries
      # joins(:director).where("directors.name" => director).count
    end

    def total_gross

      find_by_sql(["SELECT SUM(gross_earnings) from sequels"])[0].attributes["sum"].to_i

      # sum("gross_earnings")

    end

    def total_gross_by_year_after(year)
      # find_by_sql("SELECT year, gross_earnings FROM sequels WHERE year > ? GROUP BY year", year)

      where("year > ?", year).group("year").sum("gross_earnings")

    end

    def total_by_genre(genre)

        joins(:genres)
        .where("genres.name = ?", genre)
        .count

      # find_by_sql("SELECT COUNT(*) FROM sequels INNER JOIN genres_sequels ON genres_sequels.sequel_id = sequels.id INNER JOIN genres ON genres.id = genres_sequels.genre_id WHERE genres.name = ?", genre)

        # where("genre = ?", genre).count.genres
        # where("genre = ?", genre).count.joins("INNER JOIN genres_sequels ON genres_sequels.sequel_id = sequels.id INNER JOIN genres ON genres.id = genres_sequels.genre_id")

    end

    def average_gross_for(director)


      joins(:director)
      .where("directors.name = ?", director)
      .average("gross_earnings")
      .to_i

      # find_by_sql("SELECT AVG(sequels.gross_earnings) FROM sequels INNER JOIN directors ON directors.id = sequels.director_id WHERE directors.name = ?", director).to_i
      # select avg(gross_earnings) from sequels INNER JOIN directors on sequels.director_id = directors.id where directors.name = 'Steven Spielberg';

    end


    def minimum_made_by(director)
        
        joins(:director)
        .where("directors.name = ?", director)
        .minimum("gross_earnings")

         # select min(gross_earnings) from sequels inner join directors on sequels.director_id = directors.id where directors.name = 'Peter Jackson';      

    end

    def maximum_gross_before(year)
        
        where("year < ?", year)
        .maximum("gross_earnings")

        #select max(gross_earnings) from sequels where year < 2000;


    end

    def highest_grossing_by_genre_and_director(genre, director)
      
      joins(:director)
      .joins(:genres)
      .where("genres.name" => genre)
      .where("directors.name = ?", director)
      .maximum("sequels.gross_earnings")

      # NOTE: For the where clause you can do either injection
      # with ? or use =>

      # select max("gross_earnings") from sequels inner join directors on sequels.director_id = directors.id inner join genres_sequels on sequels.id = genres_sequels.sequel_id inner join genres on genres_sequels.genre_id = genres.id where genres.name = 'Action' and directors.name = 'Steven Spielberg';


    end

  end

end
