require_relative './spec_helper'
require 'ostruct'

describe BashTryHook do
  let(:hook) { BashTryHook.new(nil) }
  let(:file) { hook.compile(request) }
  let(:result) { hook.run!(file) }

  let(:goal) { {query_outputs: {query: 'echo goal', output: 'goal'}}}


  context 'simple try' do
    let(:request) { struct query: 'cd / && pwd', goal: goal }
    it { expect(result[2][:result]).to eq "/" }
    it { expect(result[1]).to eq :passed }
  end

  context 'try with extra' do
    let(:request) { struct query: 'ls', extra: "mkdir foo\ncd foo\ntouch hello\ntouch world", goal: goal}
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

  context 'multiple outputs try' do
    let(:request) { struct query: 'echo query', extra: 'echo extra', cookie: ['echo cookie'], goal: goal }
    it { expect(result[2][:result]).to eq 'query' }
  end

end
