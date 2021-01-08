require 'pp'
require 'ostruct'

class Templates
  def initialize(base_dir)
    @base_dir = base_dir
  end

  def method_missing(name, params = {})
    source = File.read("#{@base_dir}/#{name}.template")
    Template.new(source).render(params)
  end

  class Template
    def initialize(source)
      @source = source
    end

    def render(params)
      lines = @source.split("\n")
      nodes = lines.map { |line| build_node(line) }
      tree = build_tree(nodes)
      tree.render(params) + "\n"
    end

    def build_node(line)
      indentation, line = /^( *)(.*)$/.match(line).captures
      indent = indentation.length / 2
      case line[0, 2]
      when '| '
        TextNode.new(indent, line[2..-1])
      when '= '
        CodeNode.new(indent, line[2..-1])
      else
        TagNode.new(indent, line, [])
      end
    end

    def build_tree(nodes)
      root = nodes.shift
      depth_map = { 0 => root }

      nodes.each do |node|
        parent = depth_map.fetch(node.indent - 1)
        parent.children << node
        depth_map[node.indent] = node
      end

      root
    end
  end

  class TextNode < Struct.new(:indent, :text)
    def render(params)
      ' ' * (indent * 2) + text
    end
  end

  class CodeNode < Struct.new(:indent, :code)
    def render(params)
      params_binding = OpenStruct.new(params).instance_eval { binding }
      ' ' * (indent * 2) + eval(code, params_binding).to_s
    end
  end

  class TagNode < Struct.new(:indent, :tag, :children)
    def render(params)
      [
        ' ' * (indent * 2) + "<#{tag}>",
        children.map { |child| child.render(params) },
        ' ' * (indent * 2) + "</#{tag}>"
      ].flatten.join("\n")
    end
  end
end
