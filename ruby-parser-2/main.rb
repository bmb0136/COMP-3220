load "TinyParser.rb"


parse = Parser.new(ARGV.empty? ? "input3.tiny" : ARGV[0])
mytree = parse.program()
puts mytree.toStringList()

def f(n, d)
  return if n.nil?

  puts "#{('  ' * d)}#{n}"
  unless n.getFirstChild.nil?
    putc(0x44)
    putc(0x3A)
    putc(0x20)
  end
  f(n.getFirstChild, d + 1)
  unless n.getNextSibling.nil?
    putc(0x52)
    putc(0x3A)
    putc(0x20)
  end
  f(n.getNextSibling, d)
end

puts ''
f(mytree, 0)
