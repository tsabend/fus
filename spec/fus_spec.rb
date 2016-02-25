require 'spec_helper'

describe Fus::Finder do
  before :each do
    @fixtures_path = File.expand_path(File.join(__FILE__, '../fixtures'))
  end
  describe "swift_classes" do
    it "returns all of the classes in all the swift paths" do
      finder = Fus::Finder.new(@fixtures_path)
      # Any time you add a swift class to the fixtures, update this spec
      expect(finder.swift_classes).to include(
        "Foo", "ClassVar", "SuperFoo", 
        "NoSpaceSuperFoo", "UnusedClass", 
        "ObjCH", "ObjCM", "FooSpec", 
        "UsedInStoryboardView", "UsedInStoryboardViewController", 
        "UsedInXib", "ObjCHForwardDeclarationOnly", "TypeAliasClass"
      )
      expect(finder.swift_classes.count).to eq(13)
    end
  end

  describe "unused_classes" do
    it "returns classes that are never used" do
      finder = Fus::Finder.new(@fixtures_path)
      expect(finder.unused_classes).to include("UnusedClass", "ObjCHForwardDeclarationOnly")
      expect(finder.unused_classes.count).to eq(2)
    end
  end

  describe "+swift_class_is_used_in_text" do
    it "returns true if the class is initialized in the text" do
      was_used = Fus::Finder.swift_class_is_used_in_text("Foo", "Foo()")
      expect(was_used).to be_truthy
    end

    it "returns true if the class is used as a superclass with a space" do
      was_used = Fus::Finder.swift_class_is_used_in_text("Foo", "class Bar : Foo")
      expect(was_used).to be_truthy
    end

    it "returns true if the class is used as a superclass without a space" do
      was_used = Fus::Finder.swift_class_is_used_in_text("Foo", "class Bar: Foo")
      expect(was_used).to be_truthy
    end

    it "returns true if a class var is used" do
      was_used = Fus::Finder.swift_class_is_used_in_text("Foo", "Foo.magic")
      expect(was_used).to be_truthy
    end

    it "returns true if a class func is used" do
      was_used = Fus::Finder.swift_class_is_used_in_text("Foo", "Foo.magic()")
      expect(was_used).to be_truthy
    end
    
    it "returns true if a class is used as a typealias" do
      was_used = Fus::Finder.swift_class_is_used_in_text("Foo", "typealias Bar = Foo")
      expect(was_used).to be_truthy
    end

    it "returns false if the class is never used" do
      was_used = Fus::Finder.swift_class_is_used_in_text("Foo", "Bar.magic()")
      expect(was_used).to be_falsy
    end
  end

  describe "+class_is_used_in_obj_c_text" do
    it "returns true if the classname appears" do
      was_used = Fus::Finder.class_is_used_in_obj_c_text("Foo", "Foo")
      expect(was_used).to be_truthy
    end

    it "returns true if the classname appears both as a forward declaration and not as a forward declaration" do
      was_used = Fus::Finder.class_is_used_in_obj_c_text("Foo", "@Foo Foo")
      expect(was_used).to be_truthy
    end
    
    it "returns false if the classname appears only in a forward declaration" do
      was_used = Fus::Finder.class_is_used_in_obj_c_text("Foo", "@Foo")
      expect(was_used).to be_falsy
    end

    it "returns false if the classname does not appear" do
      was_used = Fus::Finder.class_is_used_in_obj_c_text("Foo", "Bar")
      expect(was_used).to be_falsy
    end
  end
  
  describe "+class_is_used_in_xml" do
    it "returns true if the classname is used as a customClass" do
      was_used = Fus::Finder.class_is_used_in_xml("Foo", '<customClass="Foo">')
      expect(was_used).to be_truthy
    end

    it "returns false if the classname does not appear as a customClass" do
      was_used = Fus::Finder.class_is_used_in_xml("Foo", "<Bar>")
      expect(was_used).to be_falsy
    end
  end

  describe "+path_matches_classname" do
    it "returns true if the path ends in classname.swift" do
      matches = Fus::Finder.path_matches_classname("Foo", "x/y/z/Foo.swift")
      expect(matches).to be_truthy
    end

    it "returns false if the path doesn't include the pathname" do
      matches = Fus::Finder.path_matches_classname("Foo", "x/y/z/Bar.swift")
      expect(matches).to be_falsy
    end

    it "returns false if the path includes the pathname and extra words" do
      matches = Fus::Finder.path_matches_classname("Foo", "x/y/z/FooBar.swift")
      expect(matches).to be_falsy
    end
  end

  describe "+class_is_spec" do
    it "returns true if the classname ends in Spec" do
      is_spec = Fus::Finder.class_is_spec("FooSpec")
      expect(is_spec).to be_truthy
    end

    it "returns false if the classname doesn't end in Spec" do
      is_spec = Fus::Finder.class_is_spec("Foo")
      expect(is_spec).to be_falsy
    end
  end
end
