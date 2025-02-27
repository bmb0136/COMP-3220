#
#  Parser Class
#
load 'TinyLexer.rb'
load 'TinyToken.rb'
load 'AST.rb'

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
    if @lookahead.type != dtype
      puts "Expected #{dtype} found #{@lookahead.text}"
      @errors_found += 1
    end
    consume
  end

  def program
    @errors_found = 0

    p = AST.new(Token.new('program', 'program'))

    p.addChild(statement) while @lookahead.type != Token::EOF

    puts "There were #{@errors_found} parse errors found."

    p
  end

  def statement
    stmt = AST.new(Token.new('statement', 'statement'))
    if @lookahead.type == Token::PRINT
      stmt = AST.new(@lookahead)
      match(Token::PRINT)
      stmt.addChild(exp)
    else
      stmt = assign
    end
    stmt
  end

  def exp
    term
    etail
  end

  def term
    factor
    ttail
  end

  def factor
    if @lookahead.type == Token::LPAREN
      match(Token::LPAREN)
      exp
      if @lookahead.type == Token::RPAREN
        match(Token::RPAREN)
      else
        match(Token::RPAREN)
      end
    elsif @lookahead.type == Token::INT
      match(Token::INT)
    elsif @lookahead.type == Token::ID
      match(Token::ID)
    else
      puts "Expected ( or INT or ID found #{@lookahead.text}"
      @errors_found += 1
      consume
    end
    fct
  end

  def ttail
    if @lookahead.type == Token::MULTOP
      match(Token::MULTOP)
      factor
      ttail
    elsif @lookahead.type == Token::DIVOP
      match(Token::DIVOP)
      factor
      ttail
    end
  end

  def etail
    if @lookahead.type == Token::ADDOP
      match(Token::ADDOP)
      term
      etail
    elsif @lookahead.type == Token::SUBOP
      match(Token::SUBOP)
      term
      etail
    end
  end

  def assign
    assgn = AST.new(Token.new('assignment', 'assignment'))
    if @lookahead.type == Token::ID
      idtok = AST.new(@lookahead)
      match(Token::ID)
      if @lookahead.type == Token::ASSGN
        assgn = AST.new(@lookahead)
        assgn.addChild(idtok)
        match(Token::ASSGN)
        assgn.addChild(exp)
      else
        match(Token::ASSGN)
      end
    else
      match(Token::ID)
    end
    assgn
  end
end
