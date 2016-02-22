require "fus/version"

module Fus
  class Finder
    attr_reader :path
    
    def initialize(path)
      @path = File.expand_path(path)
      raise Errno::ENOENT.new(path) unless Dir.exists?(@path)
    end
    
    def swift_paths
      @swift_paths ||= Dir.glob("#{path}/**/*.swift")
    end  
    
    def obj_c_paths
      @obj_c_paths ||= (Dir.glob("#{path}/**/*.m") + Dir.glob("#{path}/**/*.h"))
      .select {|path| path.scan(/-Swift.h/).empty? }
    end
    
    def swift_classes
      @swift_classes ||= swift_paths.reduce([]) do |memo, path|
        text = File.open(path).read
        memo += find_all_swift_classes(text)
      end.uniq
    end
    
    def unused_classes
      @unused_classes ||= swift_classes.reject do |classname|
        class_is_used_in_swift(classname, swift_paths) ||
        class_is_used_in_objective_c(classname, obj_c_paths)
      end
    end
    
    private
    
    def find_all_swift_classes(swift_text) 
      swift_text.scan(/class\s+([^func][^var][a-zA-Z_]+)\s*:?.*\{/).flatten
    end
    
    def class_is_used_in_swift(classname, paths)
      paths.each do |path|
        next if self.class.path_matches_classname(classname, path)
        return true if self.class.swift_class_is_used_in_text(classname, File.open(path).read)
      end
      return false
    end
    
    def class_is_used_in_objective_c(classname, paths)
      paths.each do |path|
        return true if self.class.obj_c_class_is_used_in_text(classname, File.open(path).read)
      end
      return false    
    end
    
    def self.swift_class_is_used_in_text(classname, text)
      !text.scan(/(\b#{classname}.?[.:(])|([:].?#{classname})/).flatten.empty?
    end
    
    def self.path_matches_classname(classname, path)
      !path.scan(/#{classname}\b/).empty?
    end
    
    def self.obj_c_class_is_used_in_text(classname, text)
      # return false unless path.scan(/#{classname}/).empty?
      !text.scan(/#{classname}/).flatten.empty?
    end
  end
end
