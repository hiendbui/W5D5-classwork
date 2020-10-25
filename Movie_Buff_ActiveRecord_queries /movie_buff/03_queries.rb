# == Schema Information
#
# Table name: actors
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movies
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director_id :integer
#
# Table name: castings
#
#  id          :integer      not null, primary key
#  movie_id    :integer      not null
#  actor_id    :integer      not null
#  ord         :integer

def what_was_that_one_with(those_actors)
  # Find the movies starring all `those_actors` (an array of actor names).
  # Show each movie's title and id.

  Movie
    .select(:id, :title)
    .joins(:actors)
    .where(actors: {name: those_actors})
    .group('movies.id')
    .having('COUNT(actors.id) = ?', those_actors.length)


end

def golden_age
  # Find the decade with the highest average movie score.
  Movie
    .select('AVG(score), (yr/10)*10 AS decade')
    .group('decade')
    .order('AVG(score) DESC')
    .first
    .decade
end

def costars(name)
  # List the names of the actors that the named actor has ever
  # appeared with.
  # Hint: use a subquery
  movies = Movie
    .joins(:actors)
    .where(actors: {name: name})
    .pluck(:id)



  Actor
    .joins(:movies)
    .where(movies: {id: movies})
    .where.not(name: name)
    .distinct
    .pluck(:name)

end

def actor_out_of_work
  # Find the number of actors in the database who have not appeared in a movie
  Actor
    .left_outer_joins(:movies)
    .where("movies.id IS NULL")
    .group(:name)
    .pluck("COUNT(*)").length

end

def starring(whazzername)
  # Find the movies with an actor who had a name like `whazzername`.
  # A name is like whazzername if the actor's name contains all of the
  # letters in whazzername, ignoring case, in order.

  # ex. "Sylvester Stallone" is like "sylvester" and "lester stone" but
  # not like "stallone sylvester" or "zylvester ztallone"
  Movie
    .select(:movies)
    .joins(:actors)
    .where(actors: {name: is_whazzername?(:name,whazzername)})
end

def is_whazzername?(name,whazzername)
  i = 0
  arr = whazzername.chars
  str = name.downcase
  
  until i == str.length
    arr.shift if arr.first == str[i]
    i += 1
  end
  
  return name if arr.empty?
end

def longest_career
  # Find the 3 actors who had the longest careers
  # (the greatest time between first and last movie).
  # Order by actor names. Show each actor's id, name, and the length of
  # their career.
  Actor
    .select(:id, :name, "MAX(yr) - MIN(yr) AS career")
    .joins(:movies)
    .group(:id, :name)
    .order("career DESC")
    .limit(3)
end
