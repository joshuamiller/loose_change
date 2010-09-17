require './test/test_helper'

class InheritanceTest < ActiveSupport::TestCase

  setup do
    class Parent < LooseChange::Base
      use_database "test_db"
      property :name
    end

    class Child < Parent
      property :age
    end

    class AnotherChild < Parent
    end
    
  end

  should "inherit the parent's database" do
    assert_equal Child.new.database.name, Parent.new.database.name
  end

  should "not propagate its attributes back up the chain" do
    p = Parent.new
    assert_raise NoMethodError do
      p.age = 2
    end

    c = AnotherChild.new
    assert_raise NoMethodError do
      c.age = 2
    end
  end
  
end
