require 'yaml'

module Shaf
  class DocModel
    class << self
      def find(name)
        @@docs ||= {}
        @@docs[name] ||= load(name)
        new(name) if @@docs[name]
      end

      def find!(name)
        find(name) or raise(Errors::NotFoundError, "No documentation for #{name}")
      end

      private

      def load(name)
        file = File.join(Settings.documents_dir, "#{name}.yml")
        return YAML.load(File.read(file)) if File.exist? file
      end
    end

    def initialize(name)
      @name = name
    end

    def to_s
      return "#{@name} not found" unless @@docs[@name]
      JSON.pretty_generate(@@docs[@name])
    end

    def attribute(attr)
      attr_doc = @@docs.dig(@name, 'attributes', attr.to_s)
      return attr_doc if attr_doc
      raise Errors::NotFoundError,
        "No documentation for #{@name} attribute '#{attr}'"
    end

    def link(rel)
      link_doc = @@docs.dig(@name, 'links', rel.to_s)
      return link_doc if link_doc
      raise Errors::NotFoundError,
        "No documentation for #{@name} link relation '#{rel}'"
    end

    def embedded(name)
      embed_doc = @@docs.dig(@name, 'embeds', name.to_s)
      return embed_doc if embed_doc
      raise Errors::NotFoundError,
        "No documentation for #{@name} embedded '#{name}'"
    end
  end
end