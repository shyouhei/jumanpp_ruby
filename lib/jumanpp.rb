# frozen_string_literal: true

# JUMAN++ main interface
#
#     j = Jumanpp.new(single_path: true)
#     j.process string do |ary|
#       words = ary.join(' ')
#       puts words
#     end
class Jumanpp

  # Represents a morpheme.  This class implements #to_str so you can
  # think of instances being virtually Strings.
  # 
  # @!attribute s1
  #   Expressive vocabulary
  # @!attribute s2
  #   Pronounciation
  # @!attribute s3
  #   Lemmatized morpheme
  # @!attribute c1
  #   category 1
  # @!attribute c1_id
  #   category 1's id
  # @!attribute c2
  #   category 2
  # @!attribute c2_id
  #   category 2's id
  # @!attribute k1
  #   conjugation 1
  # @!attribute k1_id
  #   conjugation 1's id
  # @!attribute k2
  #   conjugation 2
  # @!attribute k2_id
  #   conjugation 2's id
  # @!attribute s4
  #   arbitrary info that comes with this morpheme
  # @note the manual says almost nothing about what are c1/c2/k1/k2.
  Morpheme = Struct.new(
    :s1, :s2, :s3,
    :c1, :c1_id,
    :c2, :c2_id,
    :k1, :k1_id,
    :k2, :k2_id,
    :s4
  ) do

    alias to_str       s1
    alias to_s         s1
    alias surface      s1
    alias reading      s2
    alias sound        s2
    alias base         s3
    alias lemma        s3
    alias info         s4
    alias imis         s4
    alias pos          c1
    alias pos_id       c1_id
    alias spos         c2
    alias spos_id      c2_id
    alias form         k1
    alias form_id      k1_id
    alias form_type    k2
    alias form_type_id k2_id

    # convert to so-called "JUMAN Keisiki" representation
    def JUMAN_form
      to_a.map {|i|
        case i
        when " " then "\\ "
        when / / then "\"#{i}\""
        else i
        end
      }.join(" ")
    end
  end

  # @param beam        [Integer]     beam width (default 5)
  # @param single_path [true, false] whether ambiguous words are shown
  # @param partial     [true, false] accept \t or not
  # @param static      [true, false] eager load models / NN
  def initialize(beam: nil, single_path: false, partial: false, static: false)
    argv = ['jumanpp', '--juman']
    argv << '--beam' << beam if beam
    argv << '--force-single-path' if single_path
    argv << '--partial' if partial
    argv << '--static' << '--static_mdl' if static
    argv << {
      close_others: true,
      unsetenv_others: true
    }

    @argv = argv
  end

  # Feeds the argument to jumanpp engine and extract corresponding
  # output.  Yields for each word-splitted sentence, or returns an
  # enumerator of such thing if block is absent.
  # 
  # @param      lines [String, IO]               input
  # @yieldparam words [Array<Jumanpp::Morpheme>] analyzed line
  # @return           [Enumerator]               when block is not given
  # @return           [self]                     otherwise.
  def process(lines)
    return enum_for(__callee__, lines) unless block_given?

    IO.popen @argv, 'rt+:utf-8' do |fp|
      lines.each_line do |l|
        fp.puts(preprocess(l))
        fp.flush
        a = take_until_eos(fp)
        a.reject! {|i| i == "\n" }
        if a.empty?
          yield []
        else
          a.map! {|i| parse_line(i) }
          yield a.slice_before {|i| i.size == 12 }.map {|i|
            i.each {|j| j.shift if j[0] == '@' }
            i.uniq!
            case i.length when 1 then
              next Morpheme.new(*i[0])
            else
              i.map! {|j| Morpheme.new(*j) }
              next i
            end
          }
        end
      end
    end
    return self
  end

  alias each_sentence process

  # Split the input into lines of words.
  # 
  # @param  lines [String, IO] input
  # @return       [Array<Array<Jumanpp::Morpheme> >] lines of words
  def split(lines)
    process(lines).to_a
  end

  private
  def preprocess(str)
    str.tr("\u0021-\u007e", "\uff01-\uff5e")
  end

  def take_until_eos(fp)
    return fp                            \
      .each_line                         \
      .lazy                              \
      .take_while {|i| /^(EOS)?$/ !~ i } \
      .force
  end

  def parse_line(l)
    return l                           \
      .scan(/(?:\\ |[^\s"]|"[^"]*")+/) \
      .each {|i| i.gsub!(/\\ /, ' ') } \
      .each {|i| i.sub!(/\A"(.*)"\z/, '\\1') }
  end
end
