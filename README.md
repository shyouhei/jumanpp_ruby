# JumanppRuby

This gem is Ruby binding for JUMAN++

## Installation

```ruby
gem 'jumanpp_ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jumanpp_ruby

## Usage

First create an instance of Jumanpp.

```ruby
j = Jumanpp.new(single_path: true)
```

There are several options:

- beam: passed to `jumanpp -B`
- partial: same as `jumanpp --partial`
- static: same as `jumanpp --static`
- single_path: same as `jumanpp --force-single-path`

Then, you can feed strings to the analyzer by calling its `#process` method.

```ruby
j = Jumanpp.new(single_path: true)
j.process("その声は、我が友、李徴子ではないか？") # => Enumerator
```

The enumerator yields arrays of morphemes.  So for instance if you want to just split the string into words:

```ruby
j = Jumanpp.new(single_path: true)
e = j.process("メロスには政治がわからぬ。\nメロスは、村の牧人である。")
e.each do |line|
  puts line.join("/")
end

# >> メロス/に/は/政治/が/わから/ぬ/。
# >> メロス/は/、/村/の/牧人/である/。
```

Those morphemes passed into block have several other information.  If you want to vaguely simulate the `jumanpp` command:

```ruby
j = Jumanpp.new(single_path: true)
e = j.process("「天は人の上に人を造らず人の下に人を造らず」と言えり。")
e.each do |line|
  line.each do |morpheme|
    puts morpheme.JUMAN_form
  end
  puts "EOS"
end

# >> 「 「 「 特殊 1 括弧始 3 * 0 * 0 NIL
# >> 天 てん 天 名詞 6 普通名詞 1 * 0 * 0 "代表表記:天/てん 漢字読み:音 カテゴリ:場所-自然"
# >> は は は 助詞 9 副助詞 2 * 0 * 0 NIL
# >> 人 ひと 人 名詞 6 普通名詞 1 * 0 * 0 "代表表記:人/ひと 漢字読み:訓 カテゴリ:人"
# >> の の の 助詞 9 接続助詞 3 * 0 * 0 NIL
# >> 上 うえ 上 名詞 6 副詞的名詞 9 * 0 * 0 代表表記:上/うえ
# >> に に に 助詞 9 格助詞 1 * 0 * 0 NIL
# >> 人 ひと 人 名詞 6 普通名詞 1 * 0 * 0 "代表表記:人/ひと 漢字読み:訓 カテゴリ:人"
# >> を を を 助詞 9 格助詞 1 * 0 * 0 NIL
# >> 造ら つくら 造る 動詞 2 * 0 子音動詞ラ行 10 未然形 3 代表表記:造る/つくる
# >> ず ず ぬ 助動詞 5 * 0 助動詞ぬ型 27 基本連用形 4 NIL
# >> 人 ひと 人 名詞 6 普通名詞 1 * 0 * 0 "代表表記:人/ひと 漢字読み:訓 カテゴリ:人"
# >> の の の 助詞 9 接続助詞 3 * 0 * 0 NIL
# >> 下 した 下 名詞 6 普通名詞 1 * 0 * 0 "代表表記:下/した 漢字読み:訓 カテゴリ:場所-機能"
# >> に に に 助詞 9 格助詞 1 * 0 * 0 NIL
# >> 人 ひと 人 名詞 6 普通名詞 1 * 0 * 0 "代表表記:人/ひと 漢字読み:訓 カテゴリ:人"
# >> を を を 助詞 9 格助詞 1 * 0 * 0 NIL
# >> 造ら つくら 造る 動詞 2 * 0 子音動詞ラ行 10 未然形 3 代表表記:造る/つくる
# >> ず ず ぬ 助動詞 5 * 0 助動詞ぬ型 27 基本連用形 4 NIL
# >> 」 」 」 特殊 1 括弧終 4 * 0 * 0 NIL
# >> と と と 助詞 9 格助詞 1 * 0 * 0 NIL
# >> 言え いえ 言う 動詞 2 * 0 子音動詞ワ行 12 命令形 6 "代表表記:言う/いう 補文ト"
# >> り り る 接尾辞 14 動詞性接尾辞 7 子音動詞ラ行 10 基本連用形 8 代表表記:る/る
# >> 。 。 。 特殊 1 句点 1 * 0 * 0 NIL
# >> EOS
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

