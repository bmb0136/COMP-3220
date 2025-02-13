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
      puts "Found #{name} Token: #{@lookahead.text}"
    else
      puts "Expected #{dtype} found #{@lookahead.text}"
      @errors += 1
    end
    consume
  end

  def program
    puts 'Entering STMTSEQ Rule'
    statementseq
    puts "There were #{@errors} parse errors found."
  end

  def statementseq
    while @lookahead.type != Token::EOF
      puts 'Entering STMT Rule'
      statement
    end
    puts 'Exiting STMTSEQ Rule'
  end

  def statement
    case @lookahead.type
    when Token::PRINT
      match(Token::PRINT, 'PRINT')
      puts 'Entering EXP Rule'
      exp
    when Token::ID
      puts 'Entering ASSGN Rule'
      assign
    when Token::IFOP
      puts 'Entering IFSTMT Rule'
      ifstatment
    when Token::WHILEOP
      puts 'Entering LOOPSTMT Rule'
      loop
    else
      puts "Expected PRINT or ID or IF or WHILE found #{@lookahead.type}"
      @errors += 1
    end

    puts 'Exiting STMT Rule'
  end

  def ifstatment
    match(Token::IFOP, 'IF')
    puts 'Entering COMPARISON Rule'
    comparison
    match(Token::THENOP, 'THEN')
    puts 'Entering STMTSEQ Rule'
    statementseq
    match(Token::ENDOP, 'END')
  end

  def loop
    match(Token::WHILEOP, 'WHILE')
    puts 'Entering COMPARISON Rule'
    comparison
    match(Token::THENOP, 'THEN')
    puts 'Entering STMTSEQ Rule'
    statementseq
    match(Token::ENDOP, 'END')
  end

  def comparison
    puts 'Entering FACTOR Rule'
    factor
    case @lookahead.type
    when Token::LT then match(Token::LT, 'LT')
    when Token::GT then match(Token::GT, 'GT')
    when Token::ANDOP then match(Token::ANDOP, 'ANDOP')
    end
    puts 'Entering FACTOR Rule'
    factor
  end

  def assign
    match(Token::ID, 'ID')
    match(Token::ASSGN, 'ASSGN')
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
      match(@lookahead.type, @lookahead.type == Token::MULTOP ? 'MULTOP' : 'DIVOP')
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
      match(@lookahead.type, @lookahead.type == Token::ADDOP ? 'ADDOP' : 'SUBOP')
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
      match(Token::LPAREN, 'LPAREN')
      puts 'Entering EXP Rule'
      exp
      match(Token::RPAREN, 'RPAREN')
    when Token::INT then match(Token::INT, 'INT')
    when Token::ID then match(Token::ID, 'ID')
    else
      puts "Expected ( or INT or ID found #{@lookahead.type}"
      @errors += 1
    end
    puts 'Exiting FACTOR Rule'
  end
end
