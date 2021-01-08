def compress(s)
  tree = build_tree(s)
  table = build_table(tree)
  packed = ''

  s.bytes.each do |byte|
    bits = look_up_byte(table, byte)
    packed += bits.join('')
  end
  packed
end

# builds a huffman coded tree
def build_tree(s)
  bytes = s.bytes
  uniq_b = bytes.uniq
  nodes = uniq_b.map { |byte| Leaf.new(byte, bytes.count(byte)) }
  until nodes.length == 1
    node1 = nodes.delete(nodes.min_by(&:count))
    node2 = nodes.delete(nodes.min_by(&:count))
    nodes << Node.new(node1, node2, node1.count + node2.count)
  end
  nodes.fetch(0)
end

def build_table(node, path = [])
  if node.is_a? Node
    build_table(node.left, path + [0]) + build_table(node.right, path + [1])
  else
    [TableRow.new(node.byte, path)]
  end
end

def look_up_byte(table, byte)
  table.each { |row| return row.bits if row.byte == byte }
end

Node = Struct.new(:left, :right, :count)
Leaf = Struct.new(:byte, :count)
TableRow = Struct.new(:byte, :bits)

og = 'Niki is a fat cat in a deep basement of bowump'
compressed = compress(og)
p compressed, og
