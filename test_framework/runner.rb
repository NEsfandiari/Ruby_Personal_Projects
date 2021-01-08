GREEN = "\e[32m"
RED = "\e[31m"
RESET = "\e[0m"

def describe(desc, &block)
  Describe.new(desc, block).run
end

class Describe
  def initialize(desc, block, lets = {})
    @desc = desc
    @block = block
    @lets = lets
    @befores = []
  end

  def run
    puts @desc
    instance_eval(&@block)
  end

  def describe(desc, &block)
    Describe.new(desc, block, @lets.dup).run
  end

  def it(desc, &block)
    It.new(desc, block, @lets, @befores).run
  end

  def let(name, &block)
    @lets[name] = block
  end

  def before(&block)
    @befores << block
  end
end

class It
  def initialize(desc, block, lets, befores)
    @desc = desc
    @block = block
    @lets = lets
    @befores = befores
    @lets_cache = {}
  end

  def run
    $stdout.write("  - #{@desc}")

    @befores.each { |block| instance_eval(&block) }
    instance_eval(&@block)
    puts " #{GREEN}(passed)#{RESET}"
  rescue Exception => e
    puts " #{RED}(failed)#{RESET}"
    puts [
           " #{RED}* #{e}#{RESET}",
           " #{RED}* BACKTRACE:#{RESET}",
           e.backtrace
         ].flatten.map { |line| "\t#{line}" }.join("\n")
  end

  def expect(actual = nil, &block)
    Actual.new(actual || block)
  end

  def eq(expected)
    Expectations::Equal.new(expected)
  end

  def raise_error(excpetion_cls)
    Expectations::Error.new(excpetion_cls)
  end

  def method_missing(name, *args)
    if @lets_cache.key?(name)
      @lets_cache.fetch(name)
    else
      value = instance_eval(&@lets.fetch(name) { super })
      @lets_cache[name] = value
      value
    end
  end
end

class Actual
  def initialize(actual)
    @actual = actual
  end

  def to(expectation)
    expectation.run(@actual)
  end
end

class Expectations
  class Equal
    def initialize(expected)
      @expected = expected
    end

    def run(actual)
      unless actual == @expected
        raise AssertiionError.new(
                "Expected #{@expected.inspect} but got #{actual.inspect}"
              )
      end
    end
  end

  class Error
    def initialize(exception_cls)
      @exception_cls = exception_cls
    end

    def run(actual_block)
      begin
        actual_block.call
      rescue @exception_cls
        return
      rescue StandardError => e
        raise AssertiionError.new(
                "Expected #{@exception_cls.inspect} but got #{e.inspect}"
              )
      end
      raise AssertiionError.new(
              "Expected #{@exception_cls.inspect} but got nothing"
            )
    end
  end
end

class AssertiionError < RuntimeError; end

# Should and == syntax of defining tests
class Object
  def should
    ComparisonAssertion.new(self)
  end
end

class ComparisonAssertion
  def initialize(actual)
    @actual = actual
  end

  def ==(expected)
    unless @actual == expected
      raise AssertiionError.new(
              "Expected #{expected.inspect} but got #{@actual.inspect}"
            )
    end
  end
end
