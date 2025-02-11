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
    if @lookahead.type == dtype
      puts "Found #{dtype} Token: #{@lookahead.text}"
    else
      puts "Expected #{dtype} found #{@lookahead.text}"
    end
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
      match(Token::PRINT)
      puts 'Entering EXP Rule'
      exp
    else
      puts 'Entering ASSGN Rule'
      assign
    end

    puts 'Exiting STMT Rule'
  end

  def assign
    match(Token::ID)
    match(Token::ASSGN)
    puts 'Entering EXP Rule'
    exp
    puts 'Exiting ASSGN Rule'
  end

  def exp
    puts 'Entering TERM Rule'
    term
    puts 'Entering ETAIL Rule'
    etail
    puts 'Exiting EXP Rule'
  end
end
