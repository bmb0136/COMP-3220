#
#  Class Token - Encapsulates the tokens in TINY
#
#   @type - the type of token (Category)
#   @text - the text the token represents (Lexeme)
#
class Token
  attr_accessor :type, :text

  # This is the only part of this class that you need to
  # modify.
  EOF = 'eof'
  LPAREN = '('
  RPAREN = ')'
  ADDOP  = '+'
  SUBOP  = '-'
  MULOP  = '*'
  DIVOP  = '/'
  LESSOP = '<'
  GREATOP = '>'
  ANDOP = '&'
  WS = 'whitespace'
  UNKWN = 'unknown'
  ID = 'id'
  INT = 'int'
  PRINT = 'print'
  WHILE = 'while'
  IF = 'if'
  THEN = 'then'
  ASSIGN = '='

  # add the rest of the tokens needed based on the grammar
  # specified in the Scanner class "TinyScanner.rb"

  # constructor
  def initialize(type, text)
    @type = type
    @text = text
  end

  def get_type
    @type
  end

  def get_text
    @text
  end

  # to string method
  def to_s
    "#{@type} #{@text}"
  end
end

