class CreateTables < ActiveRecord::Migration
  def change

    create_table :directors do |t|
      t.string :name
      t.date :born
    end

    create_table :sequels do |t|
      t.string :title
      t.integer :gross_earnings
      t.integer :year
      t.references :director
    end

    create_table :genres_sequels do |t|
      t.references :genres
      t.references :sequels
    end

    create_table :genres do |t|
      t.string :name
    end
  end
end
