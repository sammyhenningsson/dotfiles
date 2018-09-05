module Shaf
  module Generator
    class Serializer < Base
      identifier :serializer
      usage 'generate serializer MODEL_NAME [attribute] [..]'

      def call(options = {})
        create_serializer
        create_serializer_spec if options[:specs]
        create_policy(options)
      end

      def name
        n = args.first || ""
        return n unless n.empty?
        raise Command::ArgumentError,
          "Please provide a model name when using the serializer generator!"
      end

      def plural_name
        Utils.pluralize(name)
      end

      def model_class_name
        Utils::model_name(name)
      end

      def policy_class_name
        "#{model_class_name}Policy"
      end

      def template
        'api/serializer.rb'
      end

      def spec_template
        'spec/serializer_spec.rb'
      end

      def target
        "api/serializers/#{name}_serializer.rb"
      end

      def spec_target
        "spec/serializers/#{name}_serializer_spec.rb"
      end

      def create_serializer
        content = render(template, opts)
        write_output(target, content)
      end

      def create_serializer_spec
        content = render(spec_template, opts)
        write_output(spec_target, content)
      end

      def attributes
        args[1..-1].map { |attr| ":#{attr}" }
      end

      def attributes_with_doc
        attributes.map do |attr|
          [
            "# FIXME: Write documentation for attribute #{attr}",
            "attribute #{attr}"
          ]
        end
      end

      def links
        %w(doc:up self doc:edit-form doc:delete)
      end

      def curies_with_doc
        [
          <<~EOS.split("\n")
            # Auto generated doc:  
            # Link to the documentation for a given relation of the #{name} resource.
            # This link is templated, which means that {rel} must be replaced by the
            # appropriate relation name.  
            # Method: GET  
            # Example:
            # ```
            # curl -H "Accept: application/hal+json" \\
            #      /doc/#{name}/rels/delete
            #```
            curie :doc do
              doc_curie_uri('#{name}')
            end
          EOS
        ]
      end

      def links_with_doc
        [
          collection_link,
          self_link,
          edit_link,
          delete_link,
        ]
      end

      def collection_link
        link(
          rel: "doc:up",
          desc: "Link to the collection of all #{plural_name}. " \
          "Send a POST request to this uri to create a new #{name}",
          method: "GET or POST",
          uri: "/#{plural_name}",
          uri_helper: "#{plural_name}_uri"
        )
      end

      def self_link
        link(
          rel: "self",
          desc: "Link to this #{name}",
          uri: "/#{plural_name}/5",
          uri_helper: "#{name}_uri(resource)"
        )
      end

      def edit_link
        link(
          rel: "doc:edit-form",
          desc: "Link to a form to edit this resource",
          uri: "/#{plural_name}/5/edit",
          uri_helper: "edit_#{name}_uri(resource)"
        )
      end

      def delete_link
        link(
          rel: "doc:delete",
          desc: "Link to delete this #{name}",
          method: "DELETE",
          uri: "/#{plural_name}/5",
          uri_helper: "#{name}_uri(resource)"
        )
      end

      def create_link
        link(
          rel: "doc:create-form",
          desc: "Link to a form used to create new #{name} resources",
          uri: "new_#{name}_uri",
          uri_helper: "new_#{name}_uri"
        )
      end

      def link(rel:, method: "GET", desc:, uri:, uri_helper:)
        <<~EOS.split("\n")
          # Auto generated doc:  
          # #{desc}.  
          # Method: #{method}  
          #{example(method, uri)}
          link :'#{rel}' do
            #{uri_helper}
          end
        EOS
      end

      def example(method, uri)
        method_args = ""
        case method
        when "POST"
          method_args = "\n#      -d@payload \\"
        when "PUT"
          method_args = "\n#      -X PUT -d@payload \\"
        when "DELETE"
          method_args = "\n#      -X DELETE \\"
        end

        <<~EOS.chomp
          # Example:
          # ```
          # curl -H "Accept: application/hal+json" \\
          #      -H "Authorization: abcdef" \\#{method_args}
          #      #{uri}
          #```
        EOS
      end

      def collection_with_doc
        <<~EOS.split("\n")
          collection of: '#{plural_name}' do
            link :self, #{plural_name}_uri
            link :up, root_uri

            #{create_link.join("\n  ")}
            link :'doc:create-form', new_#{name}_uri
            curie(:doc) { doc_curie_uri('#{name}') }
          end
        EOS
      end

      def opts
        {
          name: name,
          class_name: "#{model_class_name}Serializer",
          model_class_name: model_class_name,
          policy_class_name: policy_class_name,
          policy_name: "#{name}_policy",
          attributes: attributes,
          links: links,
          attributes_with_doc: attributes_with_doc,
          curies_with_doc: curies_with_doc,
          links_with_doc: links_with_doc,
          collection_with_doc: collection_with_doc,
        }
      end

      def create_policy(options)
        policy_args = ["policy", name, *args[1..-1]]
        Generator::Factory.create(*policy_args).call(options)
      end
    end
  end
end
