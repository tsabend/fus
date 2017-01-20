require 'spec_helper'

describe Fus::Finder do
  before :each do
    @fixtures_path = File.expand_path(File.join(__FILE__, '../fixtures'))
  end
  describe "swift_classnames" do
    it "returns all of the classes in all the swift paths" do
      finder = Fus::Finder.new(@fixtures_path)
      # Any time you add a swift class to the fixtures, update this spec
      swift_classnames = finder.swift_classnames
      expect(swift_classnames).to include(
        "Foo", "ClassVar", "SuperFoo", 
        "NoSpaceSuperFoo", "UnusedClass", 
        "ObjCH", "ObjCM", "FooSpec", "FooTest", "FooTests",
        "UsedInStoryboardView", "UsedInStoryboardViewController", 
        "UsedInXib", "ObjCHForwardDeclarationOnly", "TypeAliasClass", "AssociatedTypeClass"
      )
      expect(swift_classnames.count).to eq(16)
    end
  end

  describe "unused_classnames" do
    it "returns classes that are never used" do
      finder = Fus::Finder.new(@fixtures_path)
      unused_classnames = finder.unused_classnames
      expect(unused_classnames).to include("UnusedClass", "ObjCHForwardDeclarationOnly")
      expect(unused_classnames.count).to eq(2)
    end
  end
end
