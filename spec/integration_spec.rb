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
                           result: I18n.t('mumukit.interactive.goal_passed'),
                           query_result: { result: 'git version 2', status: :passed })
  end

  context 'supports last_query_equals' do
    it 'passes when the query is ok and expected' do
      response = bridge.run_try!(extra: '',
                                 content: '',
                                 query: 'ls',
                                 cookie: ['touch hello'],
                                 goal: { kind: 'last_query_equals', value: 'ls' })

      expect(response).to eq(status: :passed,
                             result: I18n.t('mumukit.interactive.goal_passed'),
                             query_result: { result: 'hello', status: :passed })
    end

    it 'passes when the query is ok but unexpected expected' do
      response = bridge.run_try!(extra: '',
                                 content: '',
                                 query: 'ls',
                                 cookie: ['touch hello'],
                                 goal: { kind: 'last_query_equals', value: 'ls -la' })

      expect(response).to eq(status: :failed,
                             result: "query should be 'ls -la' but was 'ls'",
                             query_result: { result: 'hello', status: :passed })
    end
  end

end
