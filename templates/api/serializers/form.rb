require 'shaf/formable'

module Serializers
  class Form
    extend HALPresenter

    model Shaf::Formable::Form

    attribute :method do
      (options[:method] || resource&.method || 'POST').to_s.upcase
    end

    attribute :name do
      options[:name] || resource&.name
    end

    attribute :title do
      options[:title] || resource&.title
    end

    attribute :href do
      options[:href] || resource&.href
    end

    attribute :type do
      options[:type] || resource&.type
    end

    link :self do
      options[:self_link] || resource&.self_link
    end

    post_serialize do |hash|
      fields = resource&.fields
      break if fields.nil? || fields.empty?
      hash[:fields] = fields.map do |field|
        { name: field.name, type: field.type }.tap do |f|
          f[:value] = field.value if field.has_value?
          f[:label] = field.label
        end
      end
    end
  end
end
