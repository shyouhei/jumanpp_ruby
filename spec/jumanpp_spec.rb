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
end
