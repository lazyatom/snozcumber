require 'ostruct'

Steps do
  def a_monkey_called(name)
    @monkey = OpenStruct.new(:kind => 'monkey', :name => name)
  end

  def a_donkey_called(name, args={})
    age = args[:who_is]
    @donkey = OpenStruct.new(:kind => 'donkey', :name => name, :age => age)
  end

  def i_visit_the_zoo
    @animals_seen = [@monkey, @donkey]
  end

  def i_should_have_fun_with(*names, args)
    names << args[:and]
    assert_equal names.join, @animals_seen.map { |a| a.name }.join
  end
end