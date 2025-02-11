#
#  Parser Class
#
require_relative './TinyToken'
require_relative './TinyLexer'
class Parser < Lexer
  def initialize(filename)
    super(filename)
    consume
  end

  def consume
    @lookahead = nextToken
    @lookahead = nextToken while @lookahead.type == Token::WS
  end

  def match(dtype)
    puts "Expected #{dtype} found #{@lookahead.text}" if @lookahead.type != dtype
    consume
  end

  def program
    while @lookahead.type != Token::EOF
      puts 'Entering STMT Rule'
      statement
    end
  end

  def statement
    if @lookahead.type == Token::PRINT
      puts "Found PRINT Token: #{@lookahead.text}"
      match(Token::PRINT)
      puts 'Entering EXP Rule'
      exp
    else
      puts 'Entering ASSGN Rule'
      assign
    end

    puts 'Exiting STMT Rule'
  end
end
