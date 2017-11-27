require 'spec_helper'

describe Fus::SwiftClass do
  describe "spec?" do
    it "returns true if the classname ends in Spec" do
      spec = Fus::SwiftClass.new("FooSpec")
      expect(spec.spec?).to be_truthy
    end
    
    it "returns true if the classname ends in Test" do
      spec = Fus::SwiftClass.new("FooTest")
      expect(spec.spec?).to be_truthy
    end
    
    it "returns true if the classname ends in Tests" do
      spec = Fus::SwiftClass.new("FooTests")
      expect(spec.spec?).to be_truthy
    end

    it "returns false if the classname doesn't end in Spec, Test or Tests" do
      not_spec = Fus::SwiftClass.new("FooBar")
      expect(not_spec.spec?).to be_falsy
    end
  end

  describe "matches_classname?(path)" do
    it "returns true if the path ends in classname.swift" do
      swift_class = Fus::SwiftClass.new("Foo")
      matches = swift_class.matches_classname?("x/y/z/Foo.swift")
      expect(matches).to be_truthy
    end

    it "returns true if the path ends in classname.swift for generic class" do
      swift_class = Fus::SwiftClass.new("Foo<T>")
      matches = swift_class.matches_classname?("x/y/z/Foo.swift")
      expect(matches).to be_truthy
    end

    it "returns false if the path doesn't include the pathname" do
      swift_class = Fus::SwiftClass.new("Foo")
      matches = swift_class.matches_classname?("x/y/z/Bar.swift")
      expect(matches).to be_falsy
    end

    it "returns false if the path includes the pathname and extra words" do
      swift_class = Fus::SwiftClass.new("Foo") 
      matches = swift_class.matches_classname?("x/y/z/FooBar.swift")
      expect(matches).to be_falsy
    end
  end

  describe "used_in_xml?(xml)" do
    before { @swift_class = Fus::SwiftClass.new("Foo") }
    it "returns true if the classname is used as a customClass" do
      was_used = @swift_class.used_in_xml?('<customClass="Foo">')
      expect(was_used).to be_truthy
    end

    it "returns false if the classname does not appear as a customClass" do
      was_used = @swift_class.used_in_xml?("<Bar>")
      expect(was_used).to be_falsy
    end
  end

  describe "used_in_xml?(xml) for a generic class" do
    before { @swift_class = Fus::SwiftClass.new("Foo<T>") }
    it "returns true if the classname is used as a customClass" do
      was_used = @swift_class.used_in_xml?('<customClass="Foo">')
      expect(was_used).to be_truthy
    end

    it "returns false if the classname does not appear as a customClass" do
      was_used = @swift_class.used_in_xml?("<Bar>")
      expect(was_used).to be_falsy
    end
  end

  describe "used_in_obj_c?(text)" do
    before { @swift_class = Fus::SwiftClass.new("Foo") }
    it "returns true if the classname appears" do
      was_used = @swift_class.used_in_obj_c?("Foo")
      expect(was_used).to be_truthy
    end

    it "returns true if the classname appears both as a forward declaration and not as a forward declaration" do
      was_used = @swift_class.used_in_obj_c?("@Foo Foo")
      expect(was_used).to be_truthy
    end
    
    it "returns false if the classname appears only in a forward declaration" do
      was_used = @swift_class.used_in_obj_c?("@Foo")
      expect(was_used).to be_falsy
    end

    it "returns false if the classname does not appear" do
      was_used = @swift_class.used_in_obj_c?("Bar")
      expect(was_used).to be_falsy
    end
  end

  describe "used_in_swift?(text)" do
    before { @swift_class = Fus::SwiftClass.new("Foo") }
    it "returns true if the class is initialized in the text" do
      was_used = @swift_class.used_in_swift?("Foo()")
      expect(was_used).to be_truthy
    end

    it "returns true if the class is used as a superclass with a space" do
      was_used = @swift_class.used_in_swift?("class Bar : Foo")
      expect(was_used).to be_truthy
    end

    it "returns true if the class is used as a superclass without a space" do
      was_used = @swift_class.used_in_swift?("class Bar: Foo")
      expect(was_used).to be_truthy
    end

    it "returns true if a class var is used" do
      was_used = @swift_class.used_in_swift?("Foo.magic")
      expect(was_used).to be_truthy
    end

    it "returns true if a class func is used" do
      was_used = @swift_class.used_in_swift?("Foo.magic()")
      expect(was_used).to be_truthy
    end
    
    it "returns true if a class is used as a typealias" do
      was_used = @swift_class.used_in_swift?("typealias Bar = Foo")
      expect(was_used).to be_truthy
    end
    
    it "returns true if a class is used as a typealias in a protocol" do
      was_used = @swift_class.used_in_swift?("associatedType Bar = Foo")
      expect(was_used).to be_truthy
    end

    it "returns false if the class is never used" do
      was_used = @swift_class.used_in_swift?("Bar.magic()")
      expect(was_used).to be_falsy
    end

  end  
  describe "used_in_swift?(text) for a generic class" do
    before { @swift_class = Fus::SwiftClass.new("Foo<T>") }
    it "returns true if the class is initialized in the text" do
      was_used = @swift_class.used_in_swift?("Foo()")
      expect(was_used).to be_truthy
    end

    it "returns true if the class is initialized in the text with generic parameter" do
      was_used = @swift_class.used_in_swift?("Foo<Void>()")
      expect(was_used).to be_truthy
    end

    it "returns true if the class is used as a superclass with a space" do
      was_used = @swift_class.used_in_swift?("class Bar : Foo<Void>")
      expect(was_used).to be_truthy
    end

    it "returns true if the class is used as a superclass without a space" do
      was_used = @swift_class.used_in_swift?("class Bar: Foo<Void>")
      expect(was_used).to be_truthy
    end

    it "returns true if a class var is used" do
      was_used = @swift_class.used_in_swift?("Foo.magic")
      expect(was_used).to be_truthy
    end

    it "return true if a class var is used with generic parameter" do
      was_used = @swift_class.used_in_swift?("Foo<Void>.magic")
      expect(was_used).to be_truthy
    end

    it "returns true if a class func is used" do
      was_used = @swift_class.used_in_swift?("Foo.magic()")
      expect(was_used).to be_truthy
    end

    it "returns true if a class func is used with generic parameter" do
      was_used = @swift_class.used_in_swift?("Foo<Void>.magic()")
      expect(was_used).to be_truthy
    end

    it "returns true if a class is used as a typealias" do
      was_used = @swift_class.used_in_swift?("typealias Bar = Foo")
      expect(was_used).to be_truthy
    end

    it "returns true if a class is used as a typealias with generic parameter" do
      was_used = @swift_class.used_in_swift?("typealias Bar = Foo<Void>")
      expect(was_used).to be_truthy
    end

    it "returns true if a class is used as a generic typealias" do
      was_used = @swift_class.used_in_swift?("typealias Bar<T> = Foo<T>")
      expect(was_used).to be_truthy
    end

    it "returns true if a class is used as a typealias in a protocol" do
      was_used = @swift_class.used_in_swift?("associatedType Bar = Foo")
      expect(was_used).to be_truthy
    end

    it "returns false if the class is never used" do
      was_used = @swift_class.used_in_swift?("Bar.magic()")
      expect(was_used).to be_falsy
    end

  end
end
