require 'rspec/core/rake_task'

namespace :spec do
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern    = "spec/unit/**/*_spec.rb"
  end

  RSpec::Core::RakeTask.new(:integration) do |t|
    t.pattern    = "spec/integration/**/*_spec.rb"
  end

  RSpec::Core::RakeTask.new(:rspec_integration) do |t|
    t.pattern    = "spec/rspec_integration/**/*_spec.rb"
  end
end

task :spec => ['spec:unit', 'spec:integration', 'spec:rspec_integration']
