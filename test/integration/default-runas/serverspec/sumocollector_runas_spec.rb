require 'serverspec'

# Required by serverspec
set :backend, :exec

## Use Junit formatter output, supported by jenkins
#require 'yarjuf'
#RSpec.configure do |c|
#    c.formatter = 'JUnit'
#end

describe file('/opt/SumoCollector/collector') do
  its(:size) { should > 0 }
  its(:content) { should match /^RUN_AS_USER=_sumo/ }
  let(:sudo_options) { '-u root -H' }
end

describe file('/opt/SumoCollector/logs/collector.log') do
  its(:size) { should > 0 }
  its(:content) { should match /user.name=_sumo/ }
  let(:sudo_options) { '-u root -H' }
end
