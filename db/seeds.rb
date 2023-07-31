# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

    50.times do
        Result.create([{ subject: "science", marks: "120.15", timestamp: Date.today}, {subject: "science", marks: "150.15", timestamp: "2023-7-26"}, { subject: "science", marks: "130.15", timestamp: Date.today}, { subject: "science", marks: "180.15", timestamp: Date.today}, { subject: "science", marks: "160.15", timestamp: Date.today - 4.day}, { subject: "english", marks: "90.15", timestamp: "2023-7-26"}, { subject: "science", marks: "120.15", timestamp: Date.today - 3.day}, { subject: "science", marks: "170.15", timestamp: Date.today}, { subject: "science", marks: "110.15", timestamp: Date.today - 2.day}, { subject: "science", marks: "140.15", timestamp: Date.today - 1.day}])
    end


#Character.create(name: "Luke", movie: movies.first)
