require 'fileutils'
require 'erb'
require 'ostruct'
require 'shaf/registrable_factory'

module Shaf
  module Generator
    class Factory
      extend RegistrableFactory
    end

    class Base
      attr_reader :args

      class << self
        def inherited(child)
          Factory.register(child)
        end

        def identifier(*ids)
          @identifiers = ids.flatten
        end

        def usage(str = nil, &block)
          @usage = str || block
        end
      end

      def initialize(*args)
        @args = args.dup
      end

      def template_dir
        File.expand_path('../generator/templates', __FILE__)
      end

      def read_template(file, directory = nil)
        directory ||= template_dir
        filename = File.join(directory, file)
        filename << ".erb" unless filename.end_with?(".erb")
        File.read(filename)
      end

      def render(template, locals = {})
        str = read_template(template)
        locals[:changes] ||= []
        b = OpenStruct.new(locals).instance_eval { binding }
        ERB.new(str, 0, '<>').result(b)
      rescue SystemCallError => e
        puts "Failed to render template #{template}: #{e.message}"
        raise
      end

      def write_output(file, content)
        dir = File.dirname(file)
        FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
        File.write(file, content)
        puts "Adding file: #{file}"
      end
    end
  end
end

Dir[File.join(__dir__, 'generator', '*.rb')].each { |file| require file }
