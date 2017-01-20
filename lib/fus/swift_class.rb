module Fus
  class SwiftClass
    attr_reader :name
    def initialize(name)
      @name = name
    end
    
    def spec?
      name.match(/Spec|Tests|Test/)
    end
    
    def matches_classname?(path)
      path.match(/#{name}\b/)
    end
    
    def used_in_xml?(xml)
      xml.include?("customClass=\"#{name}\"")
    end
    
    def used_in_obj_c?(text)
      text.match(/(^|[^@])#{name}/)
    end
    
    def used_in_swift?(text)
      text.match(/(\b#{name}.?[.:(])|([:].?#{name})|((typealias|associatedType)\s+.*=.+#{name})/)
    end
  end
end