load "TinyParser.rb"

parse = Parser.new(ARGV.length < 2 ? "input3.tiny" : ARGV[1])
mytree = parse.program()
puts mytree.toStringList()
