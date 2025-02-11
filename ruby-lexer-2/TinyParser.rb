#
#  Parser Class
#
require_relative './TinyToken'
require_relative './TinyLexer'
class Parser < Lexer
  def initialize(filename)
    super(filename)
    consume
    @errors = 0
  end

  def consume
    @lookahead = nextToken
    @lookahead = nextToken while @lookahead.type == Token::WS
  end

  def match(dtype, name)
    if @lookahead.type == dtype
      puts "Found #{dtype} Token: #{@lookahead.text}"
    else
      puts "Expected #{name} found #{@lookahead.text}"
      @errors += 1
    end
    consume
  end

  def program
    while @lookahead.type != Token::EOF
      puts 'Entering STMT Rule'
      statement
    end
    puts "There were #{@errors} parse errors found."
  end

  def statement
    if @lookahead.type == Token::PRINT
      match(Token::PRINT, 'PRINT')
      puts 'Entering EXP Rule'
      exp
    else
      puts 'Entering ASSGN Rule'
      assign
    end

    puts 'Exiting STMT Rule'
  end

  def assign
    match(Token::ID, 'ID')
    match(Token::ASSGN, '=')
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

  def term
    puts 'Entering FACTOR Rule'
    factor
    puts 'Entering TTAIL Rule'
    ttail
    puts 'Exiting TERM Rule'
  end

  def ttail
    if @lookahead.type == Token::MULTOP || @lookahead.type == Token::DIVOP
      match(@lookahead.type, @lookahead.type == Token::MULTOP ? '*' : '/')
      puts 'Entering FACTOR Rule'
      factor
      puts 'Entering TTAIL Rule'
      ttail
    else
      puts 'Did not find MULTOP or DIVOP Token, choosing EPSILON production'
    end
    puts 'Exiting TTAIL Rule'
  end

  def etail
    if @lookahead.type == Token::ADDOP || @lookahead.type == Token::SUBOP
      match(@lookahead.type, @lookahead.type == Token::ADDOP ? '+' : '-')
      puts 'Entering TERM Rule'
      term
      puts 'Entering ETAIL Rule'
      etail
    else
      puts 'Did not find ADDOP or SUBOP Token, choosing EPSILON production'
    end
    puts 'Exiting ETAIL Rule'
  end

  def factor
    case @lookahead.type
    when Token::LPAREN
      match(Token::LPAREN, '(')
      puts 'Entering EXP Rule'
      exp
      match(Token::RPAREN, 'RPAREN')
    when Token::INT then match(Token::INT, 'INT')
    when Token::ID then match(Token::ID, 'ID')
    else puts "Expected LPAREN or INT or ID Token found #{@lookahead.type}"
    end
    puts 'Exiting FACTOR Rule'
  end
end
