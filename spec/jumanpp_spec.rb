# coding: utf-8
require_relative 'spec_helper'

data = <<EOS
吾輩は猫である。
名前はまだ無い。
どこで生れたかとんと見当がつかぬ。
何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。
吾輩はここで始めて人間というものを見た。
EOS

describe Jumanpp do
  it { expect(Jumanpp).to be_a(Class) }

  context 'default' do
    let(:this) { Jumanpp.new }
    subject    { this }
    it         { should be_kind_of(Jumanpp) }

    describe '#split' do
      context 'one line' do
        subject    { this.split '庭には二羽鶏がいる' }
        it         { should be_kind_of(Array) }
        its(:size) { should eq(1) }
        its([0])   { should be_kind_of(Array) }
        its([0])   { should all( be_kind_of(Jumanpp::Morpheme).or(
                                 be_kind_of(Array) ) ) }

        it 'when ambiguous' do
          subject[0].grep(Array).each do |a|
            str = a[0].to_s
            expect(a).to all( be_kind_of(Jumanpp::Morpheme) )
            expect(a.map(&:to_s)).to all( eq(str) )
          end
        end
      end

      context 'multi lined' do
        subject    { this.split data }
        it         { should be_kind_of(Array) }
        its(:size) { should eq(5) }
        it         { should all( be_kind_of(Array) ) }
        it         { should all( all( be_kind_of(Jumanpp::Morpheme).or(
                                      be_kind_of(Array) ) ) ) }

        it 'ambiguous' do
          subject.each do |l|
            l.grep(Array).each do |a|
              str = a[0].to_s
              expect(a).to all( be_kind_of(Jumanpp::Morpheme) )
              expect(a.map(&:to_s)).to all( eq(str) )
            end
          end
        end
      end
    end
  end

  context 'single path' do
    let(:this) { Jumanpp.new(single_path: true) }

    describe '#split' do
      subject { this.split data }
      it      { should all( all( be_kind_of(Jumanpp::Morpheme) ) ) }
    end

    describe '#process' do

      context 'without blocks' do
        subject { this.process data }
        it      { should be_kind_of(Enumerator) }
      end

      context 'with blocks' do
        it { expect {|b| this.process(data, &b) }.to \
               yield_control.exactly(5).times }
      end
    end
  end

  context 'given empty input' do
    subject { Jumanpp.new.split '' }
    it      { should be_kind_of(Array) }
    it      { should be_empty }
  end

  context 'given empty line' do
    subject    { Jumanpp.new.split "\n" }
    it         { should be_kind_of(Array) }
    its(:size) { should eq(1) }
    it         { should all( be_kind_of(Array).and(
                             be_empty)) }
  end

  context 'given empty lines' do
    subject    { Jumanpp.new.split "\n\n" }
    it         { should be_kind_of(Array) }
    its(:size) { should eq(2) }
    it         { should all( be_kind_of(Array).and(
                             be_empty)) }
  end
end

describe Jumanpp::Morpheme do
  let(:line)         { 'q w e r t y u i o p a s' }
  subject            { Jumanpp::Morpheme.new(*line.split(' ')) }
  it                 { should be_a(Jumanpp::Morpheme) }
  its(:s1)           { should eq('q') }
  its(:s2)           { should eq('w') }
  its(:s3)           { should eq('e') }
  its(:s4)           { should eq('s') }
  its(:c1)           { should eq('r') }
  its(:c1_id)        { should eq('t') }
  its(:c2)           { should eq('y') }
  its(:c2_id)        { should eq('u') }
  its(:k1)           { should eq('i') }
  its(:k1_id)        { should eq('o') }
  its(:k2)           { should eq('p') }
  its(:k2_id)        { should eq('a') }
  its(:to_str)       { should eq('q') }
  its(:to_s)         { should eq('q') }
  its(:surface)      { should eq('q') }
  its(:reading)      { should eq('w') }
  its(:sound)        { should eq('w') }
  its(:base)         { should eq('e') }
  its(:lemma)        { should eq('e') }
  its(:info)         { should eq('s') }
  its(:imis)         { should eq('s') }
  its(:pos)          { should eq('r') }
  its(:pos_id)       { should eq('t') }
  its(:spos)         { should eq('y') }
  its(:spos_id)      { should eq('u') }
  its(:form)         { should eq('i') }
  its(:form_id)      { should eq('o') }
  its(:form_type)    { should eq('p') }
  its(:form_type_id) { should eq('a') }
  its(:JUMAN_form)   { should eq(line) }

  context 'NULL passed' do
    let(:line)  { 'q w e * 0 * 0 * 0 * 0 NIL' }
    subject     { Jumanpp::Morpheme.new(*line.split(' ')) }
    it          { should be_a(Jumanpp::Morpheme) }
    its(:s1)    { should eq('q') }
    its(:s2)    { should eq('w') }
    its(:s3)    { should eq('e') }
    its(:s4)    { should be_nil }
    its(:c1)    { should be_nil }
    its(:c1_id) { should be_nil }
    its(:c2)    { should be_nil }
    its(:c2_id) { should be_nil }
    its(:k1)    { should be_nil }
    its(:k1_id) { should be_nil }
    its(:k2)    { should be_nil }
    its(:k2_id) { should be_nil }
  end
end
