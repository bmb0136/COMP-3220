#  Class Lexer - Reads a TINY program and emits tokens
class Lexer
  # Constructor - Is passed a file to scan and outputs a token
  #               each time nextToken() is invoked.
  #   @c        - A one character lookahead
  def initialize(filename)
    @f = File.open(filename, 'r:utf-8') if File.exist?(filename)
    abort('File does not exist!') unless @f

    if !@f.eof?
      @c = @f.getc
    else
      @c = 'eof'
      @f.close
    end
  end

  def nextCh
    @c = if !@f.eof?
           @f.getc
         else
           'eof'
         end
    @c
  end

  def nextToken
    if @c == 'eof'
      return Token.new(Token::EOF, 'eof')
    elsif whitespace?(@c)
      str = ''
      while whitespace?(@c)
        str += @c
        nextCh
      end
      tok = Token.new(Token::WS, str)
      return tok
    elsif numeric?(@c)
      str = ''
      while numeric?(@c)
        str += @c
        nextCh
      end
      tok = Token.new(Token::INT, str)
      return tok
    elsif letter?(@c)
      str = ''
      while letter?(@c)
        str += @c
        nextCh
      end
      tok = if str == 'print'
              Token.new(Token::PRINT, str)
            elsif str == 'if'
              Token.new(Token::IFOP, str)
            elsif str == 'then'
              Token.new(Token::THENOP, str)
            elsif str == 'while'
              Token.new(Token::WHILEOP, str)
            elsif str == 'end'
              Token.new(Token::ENDOP, str)
            else
              Token.new(Token::ID, str)
            end
      return tok
    end

    case @c
    when '('
      tok = Token.new(Token::LPAREN, '(')
      nextCh
      tok
    when ')'
      tok = Token.new(Token::RPAREN, ')')
      nextCh
      tok
    when '+'
      tok = Token.new(Token::ADDOP, '+')
      nextCh
      tok
    when '-'
      tok = Token.new(Token::SUBOP, '-')
      nextCh
      tok
    when '/'
      tok = Token.new(Token::DIVOP, '/')
      nextCh
      tok
    when '*'
      tok = Token.new(Token::MULTOP, '*')
      nextCh
      tok
    when '='
      nextCh
      Token.new(Token::ASSGN, '=')

    when '<'
      tok = Token.new(Token::LT, @c)
      nextCh
      tok
    when '>'
      tok = Token.new(Token::GT, @c)
      nextCh
      tok
    when '&'
      tok = Token.new(Token::ANDOP, @c)
      nextCh
      tok
    else
      tok = Token.new(Token::UNKNWN, @c)
      nextCh
      tok
    end
  end
end

#
# Helper methods for Scanner
#
def letter?(lookAhead)
  lookAhead =~ /^[a-z]|[A-Z]$/
end

def numeric?(lookAhead)
  lookAhead =~ /^(\d)+$/
end

def whitespace?(lookAhead)
  lookAhead =~ /^(\s)+$/
end
