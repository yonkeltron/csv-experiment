require 'csv'

letter_range = ('a'..'z').to_a * 100
l = letter_range.length
n = 100

header = ('a'..'j').to_a

puts "Generating character sequences"
CSV.open('char_sequences.csv', 'wb') do |csv|
  csv << header
  5_000_000.times do |i|
    csv << letter_range.sample(n)
    print '.' if i % 10_000 == 0
  end
end

# puts "Generating numeric sequences"
# numeric_range = (1..4).to_a * 3
# CSV.open('num_sequences.csv', 'wb') do |csv|
#   csv << header
#   100_000.times do |i|
#     csv << numeric_range.sample(n)
#   end
# end

puts 'Done.'
