# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Answer.delete_all
Question.delete_all
# Question.destroy_all

200.times do
    created_at = Faker::Date.backwards(365 * 5)
    q = Question.create(
        # Faker is a ruby module. We are just accessing the class Hacker inside the module Faker
        title: Faker::Hacker.say_something_smart,
        body: Faker::ChuckNorris.fact,
        view_count: rand(100_000),
        created_at: created_at,
        updated_at: created_at
    )
    if q.valid?
        q.answers = rand(0..15).times.map do
            Answer.new(body: Faker::GreekPhilosophers.quote)
        end
    end
end

questions = Question.all
answers = Answer.all
puts Cowsay.say "Generated #{ questions.count } questions", :ghostbusters
puts Cowsay.say "Generated #{ answers.count } answers", :stegosaurus