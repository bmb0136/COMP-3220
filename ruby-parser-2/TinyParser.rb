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
    a = term
    b = etail
    a.setNextSibling(b)
    a
  end

  def term
    a = factor
    b = ttail
    a.setNextSibling(b)
    a
  end

  def factor
    fct = AST.new(Token.new('factor', 'factor'))
    if @lookahead.type == Token::LPAREN
      match(Token::LPAREN)
      fct = exp
      match(Token::RPAREN)
    elsif @lookahead.type == Token::INT || @lookahead.type == Token::ID
      fct = AST.new(@lookahead)
      match(@lookahead.type)
    else
      puts "Expected ( or INT or ID found #{@lookahead.text}"
      @errors_found += 1
      consume
    end
    fct
  end

  def ttail
    return nil unless @lookahead.type == Token::MULTOP || @lookahead.type == Token::DIVOP

    a = AST.new(@lookahead)
    consume
    x = factor
    y = etail

    a.addChild(x)
    a.addChild(y)
    a
  end

  def etail
    return nil unless @lookahead.type == Token::ADDOP || @lookahead.type == Token::SUBOP

    a = AST.new(@lookahead)
    consume
    x = term
    y = etail

    puts "etail: x=#{x.toStringList} y=#{y&.toStringList}"

    a.addChild(x)
    a.addChild(y)
    a
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
