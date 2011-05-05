# app_steps.rb

require 'fileutils'

Given /^the latest Kelp step definitions$/ do
  app_dir = File.join(root_dir, 'examples', "sinatra_app")
  installed_steps = File.join(app_dir, 'features', 'step_definitions', 'web_steps.rb')
  latest_steps = File.join(root_dir, 'rails_generators', 'kelp', 'templates', 'web_steps.rb')
  # Remove the installed web_steps.rb, if any, then install the latest one
  FileUtils.mkdir_p(File.dirname(installed_steps))
  FileUtils.rm(installed_steps) if File.exists?(installed_steps)
  FileUtils.cp_r(latest_steps, installed_steps)
end


When /^I run cucumber on "(.+)"$/ do |feature|
  cucumber = "#{Cucumber::RUBY_BINARY} #{Cucumber::BINARY}"
  opts = "-q --no-color"
  command = "#{cucumber} #{opts} features/#{feature}"
  app_dir = File.join(root_dir, 'examples', "sinatra_app")
  Dir.chdir(app_dir) do
    @output = `#{command}`
  end
end


Then /^the results should include:$/ do |expected_results|
  # Remove leading whitespace before comparison
  got = @output.gsub(/^\s*/, '')
  want = expected_results.gsub(/^\s*/, '')
  if !got.include?(want)
    got = @output.collect {|line| "  #{line}"}.join
    want = expected_results.collect {|line| "  #{line}"}.join
    raise("Expected:\n#{want}\nGot:\n#{got}")
  end
end

