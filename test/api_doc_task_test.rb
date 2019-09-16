require 'test_helper'
require 'shaf/rake'

module Shaf
  module Tasks
    describe ApiDocTask do
      let(:task) do
        ApiDocTask.new do |d|
          d.source_dir = '/foo'
          d.html_output_dir = '/html'
          d.yaml_output_dir = '/yaml'
        end
      end

      it "#link" do
        task.link("  link :self do").must_equal 'self'
        task.link("  link :'doc:up' do").must_equal 'doc:up'
        task.link('  link :"doc:up" do').must_equal 'doc:up'
        task.link('  link :foo_bar" do').must_equal 'foo_bar'
        task.link('  link :foo, curie :bar do').must_equal 'foo'
      end
    end
  end
end
