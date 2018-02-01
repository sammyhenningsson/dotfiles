require 'shaf/generator'

module Shaf
  module Command
    class Generate < Base

      identifier %r(gen(erate)?)
      usage Generator::Factory.usage

      def call
        in_project_root do
          Generator::Factory.create(*args).call
        rescue StandardError => e
          raise Command::ArgumentError, e.message
        end
      end
    end
  end
end
