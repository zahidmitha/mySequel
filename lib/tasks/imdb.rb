require 'httparty'
require 'debugger'
require 'json'

# Some helper methods
def normalize(str)
  str.gsub(/[\.\:\(\)]/, "").gsub(" ", "_").downcase
end

def insert(data, file)
  file_path = File.expand_path("../../../spec/fixtures/#{file}.yml",  __FILE__)

  File.open(file_path, "a+"){|f| f << data }
end


puts "what's your title?"
title = URI.escape(gets)

response = HTTParty.get("http://imdbapi.org/?business=1&limit=4&title=#{title}")

body = JSON.parse(response.body)
puts "Choices are:\n"

body.each_with_index do |value, index|
  puts "#{index}) #{value["title"]}"
end
puts "which one do you want?"

choice = gets

choice = body[choice.to_i]
title = choice["title"]

director = choice["directors"].first
director_key = normalize(choice["directors"].first)

gross = choice['business'] ? choice['business']['gross'][0]['money'].gsub(/[\$,]/, '') : nil

genres = {}

choice["genres"].each do |genre|
  key = normalize(genre)
  genres[key] = genre
end

puts "______________________________________________"
puts "directors.yml"
puts "______________________________________________\n\n"

director =  "#{director_key}:
  name: #{director}
  born:
\n"

insert(director, 'directors')

puts director
puts "______________________________________________"
puts "sequels.yml"
puts "______________________________________________\n\n"


film = "#{normalize(title)}:
  title: \"#{title}\"
  gross_earnings: #{gross}
  year: #{choice["year"]}
  director: #{director_key}
  genres: #{genres.keys.join(", ")}
"

puts film
insert(film, 'sequels')


puts "______________________________________________"
puts "genres.yml"
puts "______________________________________________\n\n"

genre_text = genres.to_a.inject("") do |str, values|
  str += "#{values.first}:
  name: #{values.last}\n"
end

insert(genre_text, 'genres')

puts genre_text

`open #{choice["imdb_url"]}`
