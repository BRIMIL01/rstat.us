require 'kpeg/compiled_parser'

class UpdateParser < KPeg::CompiledParser


  #require "#{File.dirname(__FILE__)}/../models/user"
  def initialize(str, debug=false)
    setup_parser(str, debug)
    @tags = []
    @processed = ""
  end

  def valid_user(username)
    !User.first(:username => username).nil?
  end

  attr_accessor :tags
  attr_accessor :processed



  # space = " "
  def _space
    _tmp = match_string(" ")
    set_failed_rule :_space unless _tmp
    return _tmp
  end

  # - = space*
  def __hyphen_
    while true
    _tmp = apply(:_space)
    break unless _tmp
    end
    _tmp = true
    set_failed_rule :__hyphen_ unless _tmp
    return _tmp
  end

  # allowed = < /[A-Za-z0-9\.,\-&^%\$\?!~`+=][A-Za-z0-9\.,\-&^%@#\$\?!~`+=]*/ > { text }
  def _allowed

    _save = self.pos
    while true # sequence
    _text_start = self.pos
    _tmp = scan(/\A(?-mix:[A-Za-z0-9\.,\-&^%\$\?!~`+=][A-Za-z0-9\.,\-&^%@#\$\?!~`+=]*)/)
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

  # allowed_username = < /[A-Za-z0-9\-_$\.+!\*][A-Za-z0-9\-_$\.+\*]*/ > { text }
  def _allowed_username

    _save = self.pos
    while true # sequence
    _text_start = self.pos
    _tmp = scan(/\A(?-mix:[A-Za-z0-9\-_$\.+!\*][A-Za-z0-9\-_$\.+\*]*)/)
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

    set_failed_rule :_allowed_username unless _tmp
    return _tmp
  end

  # username = "@" allowed_username:u {                             if valid_user(u)                               "<a href='/users/#{u}'>@#{u}</a>"                             else                               "@#{u}"                             end                            }
  def _username

    _save = self.pos
    while true # sequence
    _tmp = match_string("@")
    unless _tmp
      self.pos = _save
      break
    end
    _tmp = apply(:_allowed_username)
    u = @result
    unless _tmp
      self.pos = _save
      break
    end
    @result = begin; 
                            if valid_user(u)
                              "<a href='/users/#{u}'>@#{u}</a>"
                            else
                              "@#{u}"
                            end
                           ; end
    _tmp = true
    unless _tmp
      self.pos = _save
    end
    break
    end # end sequence

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

  # element = (url:u { u } | username:u { u } | tag:t { t } | allowed:a { a })
  def _element

    _save = self.pos
    while true # choice

    _save1 = self.pos
    while true # sequence
    _tmp = apply(:_url)
    u = @result
    unless _tmp
      self.pos = _save1
      break
    end
    @result = begin;  u ; end
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
    u = @result
    unless _tmp
      self.pos = _save2
      break
    end
    @result = begin;  u ; end
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
    _tmp = apply(:_tag)
    t = @result
    unless _tmp
      self.pos = _save3
      break
    end
    @result = begin;  t ; end
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
    _tmp = apply(:_allowed)
    a = @result
    unless _tmp
      self.pos = _save4
      break
    end
    @result = begin;  a ; end
    _tmp = true
    unless _tmp
      self.pos = _save4
    end
    break
    end # end sequence

    break if _tmp
    self.pos = _save
    break
    end # end choice

    set_failed_rule :_element unless _tmp
    return _tmp
  end

  # elements = (element:e - elements:s { "#{e} #{s}" } | element:e { e })
  def _elements

    _save = self.pos
    while true # choice

    _save1 = self.pos
    while true # sequence
    _tmp = apply(:_element)
    e = @result
    unless _tmp
      self.pos = _save1
      break
    end
    _tmp = apply(:__hyphen_)
    unless _tmp
      self.pos = _save1
      break
    end
    _tmp = apply(:_elements)
    s = @result
    unless _tmp
      self.pos = _save1
      break
    end
    @result = begin;  "#{e} #{s}" ; end
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
    _tmp = apply(:_element)
    e = @result
    unless _tmp
      self.pos = _save2
      break
    end
    @result = begin;  e ; end
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

    set_failed_rule :_elements unless _tmp
    return _tmp
  end

  # root = elements:e { @processed = e }
  def _root

    _save = self.pos
    while true # sequence
    _tmp = apply(:_elements)
    e = @result
    unless _tmp
      self.pos = _save
      break
    end
    @result = begin;  @processed = e ; end
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
  Rules[:_space] = rule_info("space", "\" \"")
  Rules[:__hyphen_] = rule_info("-", "space*")
  Rules[:_allowed] = rule_info("allowed", "< /[A-Za-z0-9\\.,\\-&^%\\$\\?!~`+=][A-Za-z0-9\\.,\\-&^%@\#\\$\\?!~`+=]*/ > { text }")
  Rules[:_url] = rule_info("url", "< /(http[s]?:\\/\\/\\S+[a-zA-Z0-9\\/}])/ > { \"<a href='\#{text}'>\#{text}</a>\" }")
  Rules[:_allowed_username] = rule_info("allowed_username", "< /[A-Za-z0-9\\-_$\\.+!\\*][A-Za-z0-9\\-_$\\.+\\*]*/ > { text }")
  Rules[:_username] = rule_info("username", "\"@\" allowed_username:u {                             if valid_user(u)                               \"<a href='/users/\#{u}'>@\#{u}</a>\"                             else                               \"@\#{u}\"                             end                            }")
  Rules[:_tag_name] = rule_info("tag_name", "allowed:a { @tags << a; a }")
  Rules[:_tag] = rule_info("tag", "\"\#\" tag_name:t { \"<a href='/hashtags/\#{t}'>\#\#{t}</a>\" }")
  Rules[:_element] = rule_info("element", "(url:u { u } | username:u { u } | tag:t { t } | allowed:a { a })")
  Rules[:_elements] = rule_info("elements", "(element:e - elements:s { \"\#{e} \#{s}\" } | element:e { e })")
  Rules[:_root] = rule_info("root", "elements:e { @processed = e }")
end
