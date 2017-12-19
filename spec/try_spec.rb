require_relative './spec_helper'
require 'ostruct'

describe BashTryHook do
  let(:hook) { BashTryHook.new(nil) }
  let(:file) { hook.compile(request) }
  let(:result) { hook.run!(file) }

  let(:goal) { { kind: 'query_outputs', query: 'echo goal', output: 'goal' } }

  context 'simple try' do
    let(:request) { struct query: 'cd / && pwd', goal: goal }
    it { expect(result[2][:result]).to eq "/" }
    it { expect(result[1]).to eq :passed }
  end

  context 'try with extra' do
    let(:request) { struct query: 'ls', extra: "mkdir foo\ncd foo\ntouch hello\ntouch world", goal: goal }
    it { expect(result[2][:result]).to eq "hello\nworld" }
  end

  context 'try with cookie' do
    let(:request) { struct query: 'ls', cookie: ['mkdir foo', 'cd foo', 'touch hello', 'touch world'], goal: goal }
    it { expect(result[2][:result]).to eq "hello\nworld" }
  end

  context 'try with cookie which prints to console' do
    let(:request) { struct query: 'echo bar', cookie: ['echo foo'], goal: goal }
    it { expect(result[2][:result]).to eq 'bar' }
  end

  context 'try with cd to invalid directory' do
    let(:request) { struct query: 'cat nonexistent_directory', goal: goal }
    it { expect(result[2][:result]).to eq 'cat: nonexistent_directory: No such file or directory' }
    it { expect(result[2][:status]).to eq :failed }
  end

  context 'try with multiline outputs' do
    let(:goal) { { query_outputs: { query: 'echo -e "goal1\ngoal2"', output: "goal1\ngoal2" } } }
    let(:request) { struct query: 'echo -e "query1\nquery2"', extra: 'echo -e "extra1\nextra2"', cookie: ['echo -e "cookie1\ncookie2"'], goal: goal }
    it { expect(result[2][:result]).to eq "query1\nquery2" }
  end

  context 'try with last_query_equals goal' do
    let(:goal) { { kind: 'last_query_equals', value: 'echo something' } }

    context 'and query that matches' do
      let(:request) { struct query: 'echo something', goal: goal }
      it { expect(result[1]).to eq :passed }
    end

    context 'and query that does not match' do
      let(:request) { struct query: 'echo something else', goal: goal }
      it { expect(result[1]).to eq :failed }
    end
  end

  context 'try with last_query_matches goal' do
    let(:goal) { { kind: 'last_query_matches', regexp: /echo .*/ } }

    context 'and query that matches' do
      let(:request) { struct query: 'echo something', goal: goal }
      it { expect(result[1]).to eq :passed }
    end

    context 'and query that does not match' do
      let(:request) { struct query: 'cat somewhere', goal: goal }
      it { expect(result[1]).to eq :failed }
    end
  end

  context 'try with last_query_outputs goal' do
    let(:goal) { { kind: 'last_query_outputs', output: 'something' } }

    context 'and query with said output' do
      let(:request) { struct query: 'echo something', goal: goal }
      it { expect(result[1]).to eq :passed }
    end

    context 'and query with a different output' do
      let(:request) { struct query: 'echo something else', goal: goal }
      it { expect(result[1]).to eq :failed }
    end

    context 'and query with no output' do
      let(:request) { struct query: '', goal: goal }
      it { expect(result[1]).to eq :failed }
    end
  end

  context 'try with query_fails goal' do
    let(:goal) { { kind: 'query_fails', query: 'cd somewhere' } }

    context 'and query that makes said query pass' do
      let(:request) { struct query: 'mkdir somewhere', goal: goal }
      it { expect(result[1]).to eq :failed }
    end

    context 'and query that does not make said query pass' do
      let(:request) { struct query: '', goal: goal }
      it { expect(result[1]).to eq :passed }
    end
  end

  context 'try with query_passes goal' do
    let(:goal) { { kind: 'query_passes', query: 'cd somewhere' } }

    context 'and query that makes said query pass' do
      let(:request) { struct query: 'mkdir somewhere', goal: goal }
      it { expect(result[1]).to eq :passed }
    end

    context 'nd query that does not make said query pass' do
      let(:request) { struct query: '', goal: goal }
      it { expect(result[1]).to eq :failed }
    end
  end

  context 'try with query_outputs goal' do
    let(:goal) { { kind: 'query_outputs', query: 'ls', output: 'somewhere' } }

    context 'and query that generates said output' do
      let(:request) { struct query: 'mkdir somewhere', goal: goal }
      it { expect(result[1]).to eq :passed }
    end

    context 'and query that does not generate said output' do
      let(:request) { struct query: '', goal: goal }
      it { expect(result[1]).to eq :failed }
    end
  end

  context 'try with last_query_passes goal' do
    let(:goal) { { kind: 'last_query_passes' } }

    context 'and query that passes' do
      let(:request) { struct query: 'echo something', goal: goal }
      it { expect(result[1]).to eq :passed }
    end

    context 'and query that fails' do
      let(:request) { struct query: 'cat somewhere', goal: goal }
      it { expect(result[1]).to eq :failed }
    end
  end

  context 'try with last_query_fails goal' do
    let(:goal) { { kind: 'last_query_fails' } }

    context 'and query that fails' do
      let(:request) { struct query: 'cat somewhere', goal: goal }
      it { expect(result[1]).to eq :passed }
    end

    context 'and query that passes' do
      let(:request) { struct query: 'echo something', goal: goal }
      it { expect(result[1]).to eq :failed }
    end
  end

end
