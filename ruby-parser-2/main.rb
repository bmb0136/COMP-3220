load "TinyParser.rb"

parse = Parser.new(ARGV.length == 0 ? "input3.tiny" : ARGV[0])
mytree = parse.program()
puts mytree.toStringList()
