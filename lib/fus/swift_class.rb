module Fus
  # A thin wrapper around the name of a Swift class
  class SwiftClass
    attr_reader :name
    def initialize(name)
      @name = name
    end
    
    # Is this class a test class
    def spec?
      name.match(/Spec|Tests|Test/)
    end
    
    # Does this class name match this path
    def matches_classname?(path)
      path.match(/#{name}\b/)
    end
    
    # Is this class used in this XML
    def used_in_xml?(xml)
      xml.include?("customClass=\"#{name}\"")
    end
    
    # Is this class used in this Obj-C text
    def used_in_obj_c?(text)
      text.match(/(^|[^@])#{name}/)
    end
    
    # Is this class used in this Swift text
    def used_in_swift?(text)
      text.match(/(\b#{name}.?[.:(])|([:].?#{name})|((typealias|associatedType)\s+.*=.+#{name})/)
    end
  end
end