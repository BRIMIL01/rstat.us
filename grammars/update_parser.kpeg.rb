require 'kpeg/compiled_parser'

class UpdateParser < KPeg::CompiledParser


  #require "#{File.dirname(__FILE__)}/../models/user"
  
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



  # single_at = "# "
  def _single_at
    _tmp = match_string("# ")
    set_failed_rule :_single_at unless _tmp
    return _tmp
  end

  # single_pound = "@ "
  def _single_pound
    _tmp = match_string("@ ")
    set_failed_rule :_single_pound unless _tmp
    return _tmp
  end

  # allowed_chars = < /[A-Za-z0-9.,\-&^%$?!~`+= ]/ > { text }
  def _allowed_chars

    _save = self.pos
    while true # sequence
    _text_start = self.pos
    _tmp = scan(/\A(?-mix:[A-Za-z0-9.,\-&^%$?!~`+= ])/)
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

    set_failed_rule :_allowed_chars unless _tmp
    return _tmp
  end

  # allowed = < (single_at | single_pound | allowed)+ > { text }
  def _allowed

    _save = self.pos
    while true # sequence
    _text_start = self.pos
    _save1 = self.pos

    _save2 = self.pos
    while true # choice
    _tmp = apply(:_single_at)
    break if _tmp
    self.pos = _save2
    _tmp = apply(:_single_pound)
    break if _tmp
    self.pos = _save2
    _tmp = apply(:_allowed)
    break if _tmp
    self.pos = _save2
    break
    end # end choice

    if _tmp
      while true
    
    _save3 = self.pos
    while true # choice
    _tmp = apply(:_single_at)
    break if _tmp
    self.pos = _save3
    _tmp = apply(:_single_pound)
    break if _tmp
    self.pos = _save3
    _tmp = apply(:_allowed)
    break if _tmp
    self.pos = _save3
    break
    end # end choice

        break unless _tmp
      end
      _tmp = true
    else
      self.pos = _save1
    end
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

    set_failed_rule :_allowed unless _tmp
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

  # tag_name = allowed:a { @tags << a; a }
  def _tag_name

    _save = self.pos
    while true # sequence
    _tmp = apply(:_allowed)
    a = @result
    unless _tmp
      self.pos = _save
      break
    end
    @result = begin;  @tags << a; a ; end
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

  # update = (tag:t update:u { "#{t}#{u}" } | username:n update:u { "#{n}#{u}" } | allowed:a update:u { "#{a}#{u}" } | username:u { u } | tag:t { t } | allowed:a { a })
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
    _tmp = apply(:_allowed)
    a = @result
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
    @result = begin;  "#{a}#{u}" ; end
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
    _tmp = apply(:_username)
    u = @result
    unless _tmp
      self.pos = _save4
      break
    end
    @result = begin;  u ; end
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
    _tmp = apply(:_tag)
    t = @result
    unless _tmp
      self.pos = _save5
      break
    end
    @result = begin;  t ; end
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
    _tmp = apply(:_allowed)
    a = @result
    unless _tmp
      self.pos = _save6
      break
    end
    @result = begin;  a ; end
    _tmp = true
    unless _tmp
      self.pos = _save6
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
  Rules[:_single_at] = rule_info("single_at", "\"\# \"")
  Rules[:_single_pound] = rule_info("single_pound", "\"@ \"")
  Rules[:_allowed_chars] = rule_info("allowed_chars", "< /[A-Za-z0-9.,\\-&^%$?!~`+= ]/ > { text }")
  Rules[:_allowed] = rule_info("allowed", "< (single_at | single_pound | allowed)+ > { text }")
  Rules[:_url] = rule_info("url", "< /(http[s]?:\\/\\/\\S+[a-zA-Z0-9\\/}])/ > { \"<a href='\#{text}'>\#{text}</a>\" }")
  Rules[:_allowed_username_chars] = rule_info("allowed_username_chars", "< /[A-Za-z0-9\\-_$.+!*]/ > { text }")
  Rules[:_allowed_username_ending] = rule_info("allowed_username_ending", "< /[A-Za-z0-9\\-_$.+*]/ > { text }")
  Rules[:_known_username] = rule_info("known_username", "allowed_username_chars:u* allowed_username_ending:e &{ valid_user(\"\#{u}\#{e}\") }")
  Rules[:_unknown_username] = rule_info("unknown_username", "allowed_username_chars:u* allowed_username_ending:e { \"\#{u}\#{e}\" }")
  Rules[:_username] = rule_info("username", "(\"@\" known_username:u { \"<a href='/users/\#{u}'>@\#{u}</a>\" } | \"@\" unknown_username:u { \"@\#{u}\" })")
  Rules[:_tag_name] = rule_info("tag_name", "allowed:a { @tags << a; a }")
  Rules[:_tag] = rule_info("tag", "\"\#\" tag_name:t { \"<a href='/hashtags/\#{t}'>\#\#{t}</a>\" }")
  Rules[:_update] = rule_info("update", "(tag:t update:u { \"\#{t}\#{u}\" } | username:n update:u { \"\#{n}\#{u}\" } | allowed:a update:u { \"\#{a}\#{u}\" } | username:u { u } | tag:t { t } | allowed:a { a })")
  Rules[:_root] = rule_info("root", "update:u { @processed = u }")
end
