require "fileutils"
require "renee"
require "erb"
require 'ostruct'

class Gameplan
  class SiteGenerator
    def initialize(plan)
      @plan = plan
      @root = File.expand_path("../frontend", __FILE__)
      @target = File.join(Dir.pwd, 'site')
      @template = File.read(File.join(@root, "views/layout/application.erb"))
    end

    def generate
      FileUtils.rm_rf(@target)
      FileUtils.mkdir_p(@target)
      # copy static assets
      FileUtils.cp_r(File.join(@root, 'public/js'), @target)
      FileUtils.cp_r(File.join(@root, 'public/img'), @target)
      FileUtils.cp_r(File.join(@root, 'public/css'), @target)

      generate_page('index', 'home')
      @plan.apps.values.each do |app|
        @app = app
        generate_page("app-#{app.name}", 'app')
        app.states.values.each do |state|
          @state = state
          generate_page("app-#{app.name}-state-#{state.name}", 'state')
        end
      end
    end

    def generate_page(out, name, locals = {})
      template = File.join(@root, "views/layout/application.erb")
      out_file = File.join(@target, "#{out}.html")
      File.open(out_file, 'w') do |f|
        in_file = File.join(@root, "views/#{name}.erb")
        @page = ERB.new(File.read(in_file)).result(binding)
        erb = ERB.new(File.read(template))
        f << erb.result(binding)
      end
    end
  end
end
