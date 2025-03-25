class AST
  # attr_accessor :down
  # attr_accessor :right
  # attr_accessor :token

  def initialize(tok)
    @token = tok
    @down = nil
    @right = nil
  end

  def get_token
    @token
  end

  def set_token(x)
    @token = x
  end

  def addFirstChild(node)
    return nil if node.nil?

    node.setNextSibling(@down)
    @down = node
  end

  def addChild(node)
    return nil if node.nil?

    t = @down
    if !t.nil?
      t = t.getNextSibling until t.getNextSibling.nil?
      t.setNextSibling(node)
    else
      setFirstChild(node)
    end
  end

  def getFirstChild
    @down
  end

  def setFirstChild(c)
    @down = c
  end

  def getNextSibling
    @right
  end

  def setNextSibling(n)
    @right = n
  end

  def to_s
    @token.to_s
  end

  def toStringList
    t = self
    ts = ''
    ts += ' (' unless t.getFirstChild.nil?
    ts += " #{self}"
    ts += t.getFirstChild.toStringList unless t.getFirstChild.nil?
    ts += ' )' unless t.getFirstChild.nil?
    ts += t.getNextSibling.toStringList unless t.getNextSibling.nil?
    ts
  end
end
