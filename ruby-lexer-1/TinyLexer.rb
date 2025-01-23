#
#  Class Lexer - Reads a TINY program and emits tokens
#
class Lexer
  # Constructor - Is passed a file to scan and outputs a token
  #               each time nextToken() is invoked.
  #   @c        - A one character lookahead
  def initialize(filename)
    # Need to modify this code so that the program
    # doesn't abend if it can't open the file but rather
    # displays an informative message

    return unless File.exist?(filename)

    @f = File.open(filename, 'r:utf-8')

    # Go ahead and read in the first character in the source
    # code file (if there is one) so that you can begin
    # lexing the source code file
    if !@f.eof?
      @c = @f.getc
    else
      @c = 'eof'
      @f.close
    end
  end

  # Method nextCh() returns the next character in the file
  def nextCh
    @c = if !@f.eof?
           @f.getc
         else
           'eof'
         end

    @c
  end

  # Method nextToken() reads characters in the file and returns
  # the next token
  def nextToken
    if @c == 'eof'
      Token.new(Token::EOF, 'eof')

    elsif whitespace?(@c)
      str = ''

      while whitespace?(@c)
        str += @c
        nextCh
      end

      Token.new(Token::WS, str)
    elsif letter?(@c)
      str = ''
      while letter?(@c)
        str += @c
        nextCh
      end

      type = case str
             when 'if' then Token::IF
             when 'then' then Token::THEN
             when 'while' then Token::WHILE
             when 'print' then Token::PRINT
             else Token::ID
             end
      Token.new(type, str)
    elsif numeric?(@c)
      str = ''
      while numeric?(@c)
        str += @c
        nextCh
      end

      Token.new(Token::INT, str)
    elsif @c == '='
      nextCh
      Token.new(Token::ASSIGN, '=')
    elsif @c == '('
      nextCh
      Token.new(Token::LPAREN, '(')
    elsif @c == ')'
      nextCh
      Token.new(Token::RPAREN, ')')
    elsif @c == '+'
      nextCh
      Token.new(Token::ADDOP, '+')
    elsif @c == '-'
      nextCh
      Token.new(Token::SUBOP, '-')
    elsif @c == '*'
      nextCh
      Token.new(Token::MULOP, '*')
    elsif @c == '/'
      nextCh
      Token.new(Token::DIVOP, '/')
    elsif @c == '<'
      nextCh
      Token.new(Token::LESSOP, '<')
    elsif @c == '>'
      nextCh
      Token.new(Token::GREATOP, '>')
    elsif @c == '&'
      nextCh
      Token.new(Token::ANDOP, '&')
    else
      res = Token.new(Token::UNKWN, @c)
      nextCh
      res
    end
  end
end

#
# Helper methods for Scanner
#
def letter?(look_ahead)
  look_ahead =~ /^[a-z]|[A-Z]$/
end

def numeric?(look_ahead)
  look_ahead =~ /^(\d)+$/
end

def whitespace?(look_ahead)
  look_ahead =~ /^(\s)+$/
end
