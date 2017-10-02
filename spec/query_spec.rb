require_relative './spec_helper'
require 'ostruct'

describe BashSeekHook do
  let(:hook) { BashSeekHook.new(nil) }
  let(:file) { hook.compile(request) }
  let(:result) { hook.run!(file) }


  context 'simple query' do
    let(:request) { struct query: 'cd / && pwd' }
    it { expect(result[0]).to eq "/\n" }
  end

  context 'query with extra' do
    let(:request) { struct query: 'ls', extra: "mkdir foo\ncd foo\ntouch hello\ntouch world" }
    it { expect(result[0]).to eq "hello\nworld\n" }
  end

  context 'query with cookie' do
    let(:request) { struct query: 'ls', cookie: ['mkdir foo', 'cd foo', 'touch hello', 'touch world'] }
    it { expect(result[0]).to eq "hello\nworld\n" }
  end

  context 'faulty query' do
    let(:request) { struct query: 'cat unexistent_directory' }
    it { expect(result[0]).to eq "cat: unexistent_directory: No such file or directory\n" }
    it { expect(result[1]).to eq :failed }
  end

end
