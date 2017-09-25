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
    response = bridge.run_query!(extra: '',
                                 content: '',
                                 query: 'git --version | grep "git version 2 -o"')

    expect(response).to eq(status: :passed,
                           result: 'git version 2')
  end
end
