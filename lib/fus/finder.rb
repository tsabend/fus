module Fus
  # The thing that finds the stuff
  class Finder
    attr_reader :swift_paths

    def initialize(path)
      raise Errno::ENOENT.new(path) unless Dir.exists?(path)
      path = File.expand_path(path)
      @swift_paths = Dir
          .glob("#{path}/**/*.swift")
          .select {|path| path.scan(/\/Pods\//).empty? }
      @obj_c_paths = Dir.glob("#{path}/**/*.m") + Dir.glob("#{path}/**/*.h")
        .select {|path| path.scan(/-Swift.h/).empty? }
      @ib_paths = (Dir.glob("#{path}/**/*.xib") + 
                  Dir.glob("#{path}/**/*.storyboard"))
    end

    # A list of names of unused classes
    def unused_classnames
      unused_classes.map(&:name)
    end
    
    # A list of names of all Swift classes
    def swift_classnames
      swift_classes.map(&:name)
    end
    

    private
    # Search all the swift paths and find things that look like classes
    # then map those names into SwiftClasses
    def swift_classes
      @swift_classes ||= 
      @swift_paths
      .reduce([]) { |names, path| names += find(File.open(path).read) }
      .uniq
      .map {|name| SwiftClass.new(name)}
    end
    
    # Go through the list of all Swift classes and filter out the ones
    # that are used in Swift, IB, or Obj-C
    def unused_classes
      @unused_classes ||= swift_classes.reject do |swift_class|
        swift_class.spec? ||
        used_in_swift?(swift_class) ||
        used_in_ib?(swift_class) ||
        used_in_obj_c?(swift_class)
      end
    end

    # Given some text, identify Swift classes
    def find(swift_text)
      swift_text
        .scan(/class\s+([^func][^var][a-zA-Z_]+)\s*:?\s[a-zA-Z_]*\b?\s*{/)
        .flatten
    end

    # Determines if a class is used in Swift
    def used_in_swift?(swift_class, paths=@swift_paths)
      paths.any? do |path|
        next if swift_class.matches_classname?(path)
        swift_class.used_in_swift?(File.open(path).read)
      end
    end

    # Determines if a class is used in Obj-C
    def used_in_obj_c?(swift_class, paths=@obj_c_paths)
      paths.any? { |path| swift_class.used_in_obj_c?(File.open(path).read) }
    end

    # Determines if a class is used in InterfaceBuilder
    def used_in_ib?(swift_class, paths=@ib_paths)
      paths.any? { |path| swift_class.used_in_xml?(File.open(path).read) }
    end
  end  
end
