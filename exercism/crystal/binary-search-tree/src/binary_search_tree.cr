class Node
  getter right : Node?
  getter left : Node?
  def initialize(@value : Int32) end

  def insert(val)
      if val > @value
        case r = @right
        when Node then r.insert(val)
        when Nil then @right = Node.new(val)
        end
      else
        case l = @left
        when Node then l.insert(val)
        when Nil then @left = Node.new(val)
        end
      end
  end

  def sort(node : Node? = self)
    return [] of Int32 unless node
    items = [] of Int32
    items += sort(node.left)
    items << node.value
    items + sort(node.right)
  end

  def value
    @value
  end
end
