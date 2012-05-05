require 'set'
require 'rainbow'

require 'gameplan/describe'
require 'gameplan/application'
require 'gameplan/endpoint'
require 'gameplan/flow'
require 'gameplan/state'
require 'gameplan/common_state'
require 'gameplan/pending_state'
require 'gameplan/user'
require 'gameplan/transitions'
require 'gameplan/validation'
require 'gameplan/site_generator'

class Gameplan
  include Validation

  attr_reader :apps, :flows, :last_app, :last_flow

  def load(dir)
    Dir[File.join(dir, "*.gplan")].each do |f|
      instance_eval File.read(f), f, 1
    end
    self
  end

  def initialize
    @apps = {}
    @flows = {}
    @capabilities = []
  end

  def validate_and_report
    validate
    report
  end

  def generate
    SiteGenerator.new(self).generate
  end

  def report
    puts "RUNNING GAMEPLAN\n"
    state_count = @apps.values.inject(0) { |s, a| s += a.states.size }
    endpoint_count = @apps.values.inject(0) { |s, a| s += a.states.values.inject(0) {|ss, state| ss += state.endpoints.size } }
    puts "You currently have #{@apps.size.to_s.foreground(:yellow)} apps with " <<
      "#{state_count.to_s.foreground(:yellow)} states and " <<
      "#{endpoint_count.to_s.foreground(:yellow)} endpoints defined."
    puts "You currently have #{@flows.size.to_s.foreground(:yellow)} flows defined"
    puts "#{@errors.size.to_s.foreground(:red)} errors, #{@warnings.size.to_s.foreground(:red)} warnings"
    if valid?
      puts "\nValid!".foreground(:green)
    else
      puts "\nThere were errors present:" unless errors.empty?
      errors.each { |error| puts error }
      puts "\nThere were warnings present:" unless warnings.empty?
      warnings.each { |warning| puts warning }
    end
  end

  def validate
    reset_validation!
    validate_apps
    validate_flows    
  end

  def validate_flows
    validate_flow_traversability
  end

  def validate_states
    validate_state_deadends
  end

  def validate_flow_traversability
    with_all_users do |user|
      @flows.keys.each do |name|
        puts "VALIDATING #{name.inspect}"
        test(name, user)# or add_error("Unable to traverse flow #{name}")
      end
    end
  end

  def validate_apps
    @apps.values.each { |app| app.validate }
  end

  def capabilities(*capabilities)
    @capabilities.concat(capabilities)
  end

  def app(name, type, &blk)
    @last_app = @apps[type] = Application.new(self, name, type, &blk)
    @last_app.compile
  end

  def flow(name, &blk)
    @last_flow = @flows[name] = Flow.new(self, name, &blk)
    @last_flow.compile
    flow
  end

  def travel(name, type)
    user = User.new(type)
    @flows[name].traverse(@apps[type], user)
  end

  def types
    @apps.values.map(&:name)
  end

  def test(name, user)
    types.each do |type|
      @apps.values.select { |app| app.name == user.type }.all? do |app|
        paths = @flows[name].traverse(app, user).to_a
        add_error "Failed to traverse flow #{name}" if paths.empty?
      end
    end
  end

  private
  def with_all_users
    add_warning "No flows are currently defined" if @flows.empty?
    add_warning "No apps are currently defined" if @apps.empty?
    (0..@capabilities.size).each do |i|
      @capabilities.combination(i).each do |combo|
        types.each do |type|
          yield User.new(type, *combo)
        end
      end
    end
  end
end

require 'gameplan/fuck_ruby'
