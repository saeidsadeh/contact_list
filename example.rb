puts ARGV

# create an empty hash
person = Hash.new

# add data from argument vector by using argv
person[:name] = ARGV[0]
person[:age] = ARGV[1].to_i
person[:status] = ARGV[2]

puts person




