load "TinyParser.rb"

parse = Parser.new(ARGV.empty? ? "input3.tiny" : ARGV[0])
mytree = parse.program()
puts mytree.toStringList()
