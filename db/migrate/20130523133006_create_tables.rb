class CreateTables < ActiveRecord::Migration
  def change

    create_table :directors do |t|
      t.string :name
      # This is just the year so we don't need a date column really
      t.integer :born
    end

    create_table :sequels do |t|
      t.string :title
      t.integer :gross_earnings
      t.integer :year
      t.references :director
    end

    create_table :genres_sequels do |t|
      t.references :genre
      t.references :sequel
    end

    create_table :genres do |t|
      t.string :name
    end
  end
end
