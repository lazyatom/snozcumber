module Delegate
end

module Assertions
  def assert_equal(expected, actual)
    raise "#{expected} expected but was #{actual}" unless expected == actual
  end
end

class ScenarioHandler
  include Assertions

  def initialize(name, &block)
    self.class.class_eval { include Delegate }
    @name = name
    @block = block
  end

  def run
    instance_eval(&@block)
    print "#{@name}: "
    if @pending_steps && @pending_steps.any?
      puts "The following step definitions were not found:\n\n#{@pending_steps.uniq.join("\n\n")}"
    else
      puts "PASS"
    end
  end

  def Given(*args)
  end
  alias_method :And, :Given
  alias_method :Then, :Given
  alias_method :When, :Given

  def method_missing(name, *args)
    @pending_steps ||= []
    @pending_steps << provide_definition_for_missing_step(name, *args)
  end

  private

  def provide_definition_for_missing_step(name, *args)
    if args.any?
      argument_list = args[0..-2].map.with_index { |x, i| "thing#{i+1}" }
      if args.last.is_a?(Hash)
        argument_list << "args={}"
        argument_processing = args.last.keys.map { |v| "#{v} = args[:#{v}]" }.join("\n")
      else
        argument_list << "thing#{args.length}"
        argument_processing = nil
      end
    else
      argument_list = []
      argument_processing = nil
    end
    step_body = [argument_processing, "# your code here"].compact.join("\n  ")

    return %{def #{name} #{argument_list.join(", ")}
  #{step_body}
end}
  end
end

def Scenario(name, &block)
  ScenarioHandler.new(name, &block).run
end

def Steps(&block)
  Delegate.send(:include, Module.new(&block))
end

require "steps"