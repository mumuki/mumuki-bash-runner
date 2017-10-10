require_relative './spec_helper'
require 'mumukit/bridge'
require 'active_support/all'

describe 'runner' do
  let(:bridge) { Mumukit::Bridge::Runner.new('http://localhost:4569') }

  before(:all) do
    @pid = Process.spawn 'rackup -p 4569', err: '/dev/null'
    sleep 3
  end
  after(:all) { Process.kill 'TERM', @pid }

  it 'answers the right git version' do
    response = bridge.run_try!(extra: '',
                                content: '',
                                query: 'git --version | grep "git version 2" -o',
                                goal: { kind: 'query_outputs', query: 'echo something', output: 'something' })

    expect(response).to eq(status: :passed,
                           result: I18n.t(:goal_passed),
                           query_result: { result: 'git version 2', status: :passed })
  end
end
