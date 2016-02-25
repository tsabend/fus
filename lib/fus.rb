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
    
    def storyboard_xib_paths
      @storyboard_xib_paths ||= (Dir.glob("#{path}/**/*.xib") + Dir.glob("#{path}/**/*.storyboard"))
    end

    def swift_classes
      @swift_classes ||= swift_paths.reduce([]) do |memo, path|
        text = File.open(path).read
        memo += find_all_swift_classes(text)
      end.uniq
    end

    def unused_classes
      @unused_classes ||= swift_classes.reject do |classname|
        self.class.class_is_spec(classname) ||
        class_is_used_in_swift(classname) ||
        class_is_used_in_storyboards(classname) ||
        class_is_used_in_objective_c(classname)
      end
    end

    private

    def find_all_swift_classes(swift_text)
      swift_text.scan(/class\s+([^func][^var][a-zA-Z_]+)\s*:?\s[a-zA-Z_]*\b?\s*{/).flatten
    end

    def class_is_used_in_swift(classname, paths=swift_paths)
      paths.each do |path|
        next if self.class.path_matches_classname(classname, path)
        return true if self.class.swift_class_is_used_in_text(classname, File.open(path).read)
      end
      return false
    end

    def class_is_used_in_objective_c(classname, paths=obj_c_paths)
      paths.each do |path|
        return true if self.class.class_is_used_in_obj_c_text(classname, File.open(path).read)
      end
      return false
    end

    def class_is_used_in_storyboards(classname, paths=storyboard_xib_paths)
      paths.each do |path|
        return true if self.class.class_is_used_in_xml(classname, File.open(path).read)
      end
      return false
    end

    def self.swift_class_is_used_in_text(classname, text)
      text.match(/(\b#{classname}.?[.:(])|([:].?#{classname})|(typealias\s+.*=.+#{classname})/)
    end

    def self.path_matches_classname(classname, path)
      !path.scan(/#{classname}\b/).empty?
    end

    def self.class_is_used_in_obj_c_text(classname, text)
      text.match(/(^|[^@])#{classname}/)
    end
  
    def self.class_is_used_in_xml(classname, xml)
      xml.include?("customClass=\"#{classname}\"")
    end
    
    def self.class_is_spec(classname)
      !!classname.match(/Spec$/)
    end
  end
end
