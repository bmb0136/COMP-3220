load './TinyToken.rb'
load './TinyLexer.rb'
# if the file(s) are in the same directory, you can simply precede
# the file name(s) with ./

# input.tiny below is simply the "source code"
# that you write that adheres to your grammar rules
# if it is in the same directory as this file, you can
# simply include the file name, otherwise, you will need
# to specify the entire path to the file as we did above
# to load the other ruby modules
scan = Lexer.new('input.tiny')
tok = scan.nextToken

# the code below will open a file so that I
# can save tokens to it
token_file = File.open('tokens', 'w')

# keep "fetching" one token at a time, using your scanner
# until there are no tokens left to scan
while tok.get_type != Token::EOF

  puts "Next token is: #{tok.get_type} Next lexeme is: #{tok.get_text}"

  # The instruction below writes your token into a file.
  token_file.puts tok.to_s

  # get the next token available
  tok = scan.nextToken
end

# There should be one token left (see the boolean condition above)
# putting the last token in the file and closing the file
token_file.puts tok.to_s
token_file.close

