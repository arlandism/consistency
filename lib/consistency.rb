module Consistency
  VERSION = '0.0.1'.freeze

  # Main API
  # Generate timestamp-based file to keep
  # track of actions that haven't been run yet
  def self.gen_consistency_action(action_name)
    timestamp_prefix = DateTime.now.iso8601[0..18].downcase.gsub('-', '').gsub('t', '').gsub(':', '')

  end

  # Set default action directory
  def self.initialize!(options = {})
    @dir = options.fetch(:consistency_directory, 'consistency')
    Dir.mkdir(@dir)
    @adapter = AdapterFactory.adapter(options.fetch(:adapter, :sql))
  end

  def self.run_actions!(step = nil)
    last_action = @adapter.most_recent_action

    start_index = actions.index(last_action.name) + 1
    run_actions_in_sequence(start_index, :forward, step)
  end

  def self.reverse_actions!(step = nil)
    actions = Dir.glob(File.join(@dir, '*'))
    run_actions_in_sequence(actions.length - 1, :backward, step)
  end

  def self.run_actions_in_sequence(start_index, direction, step)
    actions = Dir.glob(File.join(@dir, '*'))
    num_steps = 0
    actions[start_index..-1].each do |action|
      break if step && num_steps > step
      if direction == :forward
        Action.new(action).forward
      else
        Action.new(action).backward
      end
      num_steps += 1
    end
  end

  # class MyDataScript < Consistency::Action
  #   def forward
  #   end
  #
  #   def backward
  #   end
  # end
end
