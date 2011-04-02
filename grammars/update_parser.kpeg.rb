require 'kpeg/compiled_parser'

class UpdateParser < KPeg::CompiledParser


  require "#{File.dirname(__FILE__)}/../models/user"
  
	def initialize(str, debug=false)
    setup_parser(str, debug)
		@tags = []
		@processed = ""
	end

  def valid_user(userame)
    !User.first(:username => username).nil?
  end
  
  attr_accessor :tags
  attr_accessor :processed



  # word = < /\w+/ > { text }
  def _word

    _save = self.pos
    while true # sequence
    _text_start = self.pos
    _tmp = scan(/\A(?-mix:\w+)/)
    if _tmp
      text = get_text(_text_start)
    end
    unless _tmp
      self.pos = _save
      break
    end
    @result = begin;  text ; end
    _tmp = true
    unless _tmp
      self.pos = _save
    end
    break
    end # end sequence

    set_failed_rule :_word unless _tmp
    return _tmp
  end

  # allowed_punc = < /[.,\-&^%$@#!~`+=-] / > { text }
  def _allowed_punc

    _save = self.pos
    while true # sequence
    _text_start = self.pos
    _tmp = scan(/\A(?-mix:[.,\-&^%$@#!~`+=-] )/)
    if _tmp
      text = get_text(_text_start)
    end
    unless _tmp
      self.pos = _save
      break
    end
    @result = begin;  text ; end
    _tmp = true
    unless _tmp
      self.pos = _save
    end
    break
    end # end sequence

    set_failed_rule :_allowed_punc unless _tmp
    return _tmp
  end

  # space = " "
  def _space
    _tmp = match_string(" ")
    set_failed_rule :_space unless _tmp
    return _tmp
  end

  # url = < /(http[s]?:\/\/\S+[a-zA-Z0-9\/}])/ > { "<a href='#{text}'>#{text}</a>" }
  def _url

    _save = self.pos
    while true # sequence
    _text_start = self.pos
    _tmp = scan(/\A(?-mix:(http[s]?:\/\/\S+[a-zA-Z0-9\/}]))/)
    if _tmp
      text = get_text(_text_start)
    end
    unless _tmp
      self.pos = _save
      break
    end
    @result = begin;  "<a href='#{text}'>#{text}</a>" ; end
    _tmp = true
    unless _tmp
      self.pos = _save
    end
    break
    end # end sequence

    set_failed_rule :_url unless _tmp
    return _tmp
  end

  # allowed_username_chars = < /[A-Za-z0-9\-_$.+!*]/ > { text }
  def _allowed_username_chars

    _save = self.pos
    while true # sequence
    _text_start = self.pos
    _tmp = scan(/\A(?-mix:[A-Za-z0-9\-_$.+!*])/)
    if _tmp
      text = get_text(_text_start)
    end
    unless _tmp
      self.pos = _save
      break
    end
    @result = begin;  text ; end
    _tmp = true
    unless _tmp
      self.pos = _save
    end
    break
    end # end sequence

    set_failed_rule :_allowed_username_chars unless _tmp
    return _tmp
  end

  # allowed_username_ending = < /[A-Za-z0-9\-_$.+*]/ > { text }
  def _allowed_username_ending

    _save = self.pos
    while true # sequence
    _text_start = self.pos
    _tmp = scan(/\A(?-mix:[A-Za-z0-9\-_$.+*])/)
    if _tmp
      text = get_text(_text_start)
    end
    unless _tmp
      self.pos = _save
      break
    end
    @result = begin;  text ; end
    _tmp = true
    unless _tmp
      self.pos = _save
    end
    break
    end # end sequence

    set_failed_rule :_allowed_username_ending unless _tmp
    return _tmp
  end

  # known_username = allowed_username_chars:u* allowed_username_ending:e &{ valid_user("#{u}#{e}") }
  def _known_username

    _save = self.pos
    while true # sequence
    while true
    _tmp = apply(:_allowed_username_chars)
    u = @result
    break unless _tmp
    end
    _tmp = true
    unless _tmp
      self.pos = _save
      break
    end
    _tmp = apply(:_allowed_username_ending)
    e = @result
    unless _tmp
      self.pos = _save
      break
    end
    _save2 = self.pos
    _tmp = begin;  valid_user("#{u}#{e}") ; end
    self.pos = _save2
    unless _tmp
      self.pos = _save
    end
    break
    end # end sequence

    set_failed_rule :_known_username unless _tmp
    return _tmp
  end

  # unknown_username = allowed_username_chars:u* allowed_username_ending:e { "#{u}#{e}" }
  def _unknown_username

    _save = self.pos
    while true # sequence
    while true
    _tmp = apply(:_allowed_username_chars)
    u = @result
    break unless _tmp
    end
    _tmp = true
    unless _tmp
      self.pos = _save
      break
    end
    _tmp = apply(:_allowed_username_ending)
    e = @result
    unless _tmp
      self.pos = _save
      break
    end
    @result = begin;  "#{u}#{e}" ; end
    _tmp = true
    unless _tmp
      self.pos = _save
    end
    break
    end # end sequence

    set_failed_rule :_unknown_username unless _tmp
    return _tmp
  end

  # username = ("@" known_username:u { "<a href='/users/#{u}'>@#{u}</a>" } | "@" unknown_username:u { "@#{u}" })
  def _username

    _save = self.pos
    while true # choice

    _save1 = self.pos
    while true # sequence
    _tmp = match_string("@")
    unless _tmp
      self.pos = _save1
      break
    end
    _tmp = apply(:_known_username)
    u = @result
    unless _tmp
      self.pos = _save1
      break
    end
    @result = begin;  "<a href='/users/#{u}'>@#{u}</a>" ; end
    _tmp = true
    unless _tmp
      self.pos = _save1
    end
    break
    end # end sequence

    break if _tmp
    self.pos = _save

    _save2 = self.pos
    while true # sequence
    _tmp = match_string("@")
    unless _tmp
      self.pos = _save2
      break
    end
    _tmp = apply(:_unknown_username)
    u = @result
    unless _tmp
      self.pos = _save2
      break
    end
    @result = begin;  "@#{u}" ; end
    _tmp = true
    unless _tmp
      self.pos = _save2
    end
    break
    end # end sequence

    break if _tmp
    self.pos = _save
    break
    end # end choice

    set_failed_rule :_username unless _tmp
    return _tmp
  end

  # tag_name = word:w { @tags << w; w }
  def _tag_name

    _save = self.pos
    while true # sequence
    _tmp = apply(:_word)
    w = @result
    unless _tmp
      self.pos = _save
      break
    end
    @result = begin;  @tags << w; w ; end
    _tmp = true
    unless _tmp
      self.pos = _save
    end
    break
    end # end sequence

    set_failed_rule :_tag_name unless _tmp
    return _tmp
  end

  # tag = "#" tag_name:t { "<a href='/hashtags/#{t}'>##{t}</a>" }
  def _tag

    _save = self.pos
    while true # sequence
    _tmp = match_string("#")
    unless _tmp
      self.pos = _save
      break
    end
    _tmp = apply(:_tag_name)
    t = @result
    unless _tmp
      self.pos = _save
      break
    end
    @result = begin;  "<a href='/hashtags/#{t}'>##{t}</a>" ; end
    _tmp = true
    unless _tmp
      self.pos = _save
    end
    break
    end # end sequence

    set_failed_rule :_tag unless _tmp
    return _tmp
  end

  # update = (tag:t update:u { "#{t}#{u}" } | username:n update:u { "#{n}#{u}" } | word:w update:u { "#{w}#{u}" } | space:s update:u { " #{u}" } | url:url update:u { "#{url}#{u}" } | allowed_punc:p update:u { "#{p}#{u}" } | word:w { w } | space { " " } | url:u { u } | username:u { u } | tag:t { t } | allowed_punc:p { p })
  def _update

    _save = self.pos
    while true # choice

    _save1 = self.pos
    while true # sequence
    _tmp = apply(:_tag)
    t = @result
    unless _tmp
      self.pos = _save1
      break
    end
    _tmp = apply(:_update)
    u = @result
    unless _tmp
      self.pos = _save1
      break
    end
    @result = begin;  "#{t}#{u}" ; end
    _tmp = true
    unless _tmp
      self.pos = _save1
    end
    break
    end # end sequence

    break if _tmp
    self.pos = _save

    _save2 = self.pos
    while true # sequence
    _tmp = apply(:_username)
    n = @result
    unless _tmp
      self.pos = _save2
      break
    end
    _tmp = apply(:_update)
    u = @result
    unless _tmp
      self.pos = _save2
      break
    end
    @result = begin;  "#{n}#{u}" ; end
    _tmp = true
    unless _tmp
      self.pos = _save2
    end
    break
    end # end sequence

    break if _tmp
    self.pos = _save

    _save3 = self.pos
    while true # sequence
    _tmp = apply(:_word)
    w = @result
    unless _tmp
      self.pos = _save3
      break
    end
    _tmp = apply(:_update)
    u = @result
    unless _tmp
      self.pos = _save3
      break
    end
    @result = begin;  "#{w}#{u}" ; end
    _tmp = true
    unless _tmp
      self.pos = _save3
    end
    break
    end # end sequence

    break if _tmp
    self.pos = _save

    _save4 = self.pos
    while true # sequence
    _tmp = apply(:_space)
    s = @result
    unless _tmp
      self.pos = _save4
      break
    end
    _tmp = apply(:_update)
    u = @result
    unless _tmp
      self.pos = _save4
      break
    end
    @result = begin;  " #{u}" ; end
    _tmp = true
    unless _tmp
      self.pos = _save4
    end
    break
    end # end sequence

    break if _tmp
    self.pos = _save

    _save5 = self.pos
    while true # sequence
    _tmp = apply(:_url)
    url = @result
    unless _tmp
      self.pos = _save5
      break
    end
    _tmp = apply(:_update)
    u = @result
    unless _tmp
      self.pos = _save5
      break
    end
    @result = begin;  "#{url}#{u}" ; end
    _tmp = true
    unless _tmp
      self.pos = _save5
    end
    break
    end # end sequence

    break if _tmp
    self.pos = _save

    _save6 = self.pos
    while true # sequence
    _tmp = apply(:_allowed_punc)
    p = @result
    unless _tmp
      self.pos = _save6
      break
    end
    _tmp = apply(:_update)
    u = @result
    unless _tmp
      self.pos = _save6
      break
    end
    @result = begin;  "#{p}#{u}" ; end
    _tmp = true
    unless _tmp
      self.pos = _save6
    end
    break
    end # end sequence

    break if _tmp
    self.pos = _save

    _save7 = self.pos
    while true # sequence
    _tmp = apply(:_word)
    w = @result
    unless _tmp
      self.pos = _save7
      break
    end
    @result = begin;  w ; end
    _tmp = true
    unless _tmp
      self.pos = _save7
    end
    break
    end # end sequence

    break if _tmp
    self.pos = _save

    _save8 = self.pos
    while true # sequence
    _tmp = apply(:_space)
    unless _tmp
      self.pos = _save8
      break
    end
    @result = begin;  " " ; end
    _tmp = true
    unless _tmp
      self.pos = _save8
    end
    break
    end # end sequence

    break if _tmp
    self.pos = _save

    _save9 = self.pos
    while true # sequence
    _tmp = apply(:_url)
    u = @result
    unless _tmp
      self.pos = _save9
      break
    end
    @result = begin;  u ; end
    _tmp = true
    unless _tmp
      self.pos = _save9
    end
    break
    end # end sequence

    break if _tmp
    self.pos = _save

    _save10 = self.pos
    while true # sequence
    _tmp = apply(:_username)
    u = @result
    unless _tmp
      self.pos = _save10
      break
    end
    @result = begin;  u ; end
    _tmp = true
    unless _tmp
      self.pos = _save10
    end
    break
    end # end sequence

    break if _tmp
    self.pos = _save

    _save11 = self.pos
    while true # sequence
    _tmp = apply(:_tag)
    t = @result
    unless _tmp
      self.pos = _save11
      break
    end
    @result = begin;  t ; end
    _tmp = true
    unless _tmp
      self.pos = _save11
    end
    break
    end # end sequence

    break if _tmp
    self.pos = _save

    _save12 = self.pos
    while true # sequence
    _tmp = apply(:_allowed_punc)
    p = @result
    unless _tmp
      self.pos = _save12
      break
    end
    @result = begin;  p ; end
    _tmp = true
    unless _tmp
      self.pos = _save12
    end
    break
    end # end sequence

    break if _tmp
    self.pos = _save
    break
    end # end choice

    set_failed_rule :_update unless _tmp
    return _tmp
  end

  # root = update:u { @processed = u }
  def _root

    _save = self.pos
    while true # sequence
    _tmp = apply(:_update)
    u = @result
    unless _tmp
      self.pos = _save
      break
    end
    @result = begin;  @processed = u ; end
    _tmp = true
    unless _tmp
      self.pos = _save
    end
    break
    end # end sequence

    set_failed_rule :_root unless _tmp
    return _tmp
  end

  Rules = {}
  Rules[:_word] = rule_info("word", "< /\\w+/ > { text }")
  Rules[:_allowed_punc] = rule_info("allowed_punc", "< /[.,\\-&^%$@\#!~`+=-] / > { text }")
  Rules[:_space] = rule_info("space", "\" \"")
  Rules[:_url] = rule_info("url", "< /(http[s]?:\\/\\/\\S+[a-zA-Z0-9\\/}])/ > { \"<a href='\#{text}'>\#{text}</a>\" }")
  Rules[:_allowed_username_chars] = rule_info("allowed_username_chars", "< /[A-Za-z0-9\\-_$.+!*]/ > { text }")
  Rules[:_allowed_username_ending] = rule_info("allowed_username_ending", "< /[A-Za-z0-9\\-_$.+*]/ > { text }")
  Rules[:_known_username] = rule_info("known_username", "allowed_username_chars:u* allowed_username_ending:e &{ valid_user(\"\#{u}\#{e}\") }")
  Rules[:_unknown_username] = rule_info("unknown_username", "allowed_username_chars:u* allowed_username_ending:e { \"\#{u}\#{e}\" }")
  Rules[:_username] = rule_info("username", "(\"@\" known_username:u { \"<a href='/users/\#{u}'>@\#{u}</a>\" } | \"@\" unknown_username:u { \"@\#{u}\" })")
  Rules[:_tag_name] = rule_info("tag_name", "word:w { @tags << w; w }")
  Rules[:_tag] = rule_info("tag", "\"\#\" tag_name:t { \"<a href='/hashtags/\#{t}'>\#\#{t}</a>\" }")
  Rules[:_update] = rule_info("update", "(tag:t update:u { \"\#{t}\#{u}\" } | username:n update:u { \"\#{n}\#{u}\" } | word:w update:u { \"\#{w}\#{u}\" } | space:s update:u { \" \#{u}\" } | url:url update:u { \"\#{url}\#{u}\" } | allowed_punc:p update:u { \"\#{p}\#{u}\" } | word:w { w } | space { \" \" } | url:u { u } | username:u { u } | tag:t { t } | allowed_punc:p { p })")
  Rules[:_root] = rule_info("root", "update:u { @processed = u }")
end
