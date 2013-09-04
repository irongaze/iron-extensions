require 'date'

class String

  # Provide helper for nil/"" blankness checker
  def blank?
    empty?
  end

  def prepend(str)
    self.insert(0, str.to_s)
  end
  
  def append(str)
    self.insert(-1, str.to_s)
  end

  # Date.parse sucks hard (assumes EU formatting, for one, does the wrong thing with 2 digit years for two... etc.)
  # so we have this here as our personal, bona-fide date parsing helper.
  def to_date
    us_format = /^([0-9]{1,2})[-\/\.]([0-9]{1,2})[-\/\.]([0-9]+)$/        # US standard MM/DD/YYYY, allowing for 2 digit year
    db_format = /^([0-9]{4})[-\/\.]([0-9]{2})[-\/\.]([0-9]{2})$/  # More sane, but less common YYYY-MM-DD

    if self.match(us_format)
      m, d, y = self.extract(us_format)
    elsif self.match(db_format)
      y, m, d = self.extract(db_format)
    else
      return nil
    end
    
    y = y.to_i
    if y < 100
      # Ok, we'll let you do this 2 digit thing, but only because we like you.
      # Assume that 10 years in the future is as far as we're interested in.
      cutoff = Date.today.year - 2000 + 10
      y += (y < cutoff) ? 2000 : 1900
    end
    Date.new(y,m.to_i,d.to_i) rescue nil
  end

  # Returns the various captured elements from this string with the regex applied.
  #   Usage:  a,b = 'abc123 is cool'.extract(/([a-z]*)([0-9]*)/)
  #     => a = 'abc', b = '123'
  # With no capture in regex, returns full match
  # If no match, returns nil
  def extract(regex)
    data = self.match(regex)
    return nil unless data
    if data.size > 2
      return *(data.to_a[1..-1])
    elsif data.size == 2
      return data[1]
    else
      return data[0]
    end
  end

  # Simple parse-and-replace code, use eg: "My name is :name:".replace_vars(@person), will call #name on @person
  # and insert into place of :name:.  You can also pass in a hash to
  # source the variable values, eg: "I like :food:!".replace_vars({:food => 'eggs'})
  def replace_vars(obj)
    self.gsub(/:([a-z0-9_]+):/) do |match|
      verb = Regexp.last_match[1].intern
      if obj.is_a?(Hash)
        obj[verb].to_s
      elsif obj.respond_to?(verb)
        obj.send(verb).to_s
      else
        ":#{verb}:"
      end
    end
  end

  # To a permalink-style string rep, removing all non-word characters and dasherizing all spaces
  def to_dashcase
    s = self.dup
    s.gsub!(/\'/,'')    # remove ' from rob's, so we don't get rob-s-blog
    s.gsub!(/\W+/, ' ') # all non-word chars to spaces
    s.gsub!('_',' ')    # we don't like underscores
    s.strip!            # ooh la la
    s.downcase!         #
    s.gsub!(/\ +/, '-') # spaces to dashes, preferred separator char everywhere
    s
  end
  alias_method :to_permalink, :to_dashcase

  # Truncate a string to no more than len characters, honoring
  # word boundaries (whitespace and - character)
  def smart_truncate(len = 30, ending = '...')
    len = Math.max(len, 5)
    return self if self.length <= len
    s = self[0...(len-2)].reverse
    bits = s.split(/[\s\-,]/,2)
    s = bits.length == 2 ? bits[1] : bits[0]
    s.reverse + ending
  end

  # Returns an array that can be compared (eg via Array#sort) with another string's natural order
  # to implement natural order sorting ("Bob123" => ['BOB', 123])
  def natural_order(nocase=true)
    i = true
    str = self
    str = str.upcase if nocase
    str.gsub(/\s+/, '').split(/(\d+)/).map {|x| (i = !i) ? x.to_i : x}
  end

  # Intelligently pluralize a phrase, looking for an initial number and doing the right thing if it's found.
  # Also handles ignoring punctuation.
  #   "Buy 2 widget!".smart_pluralize => "Buy 2 widgets!"
  # Requires Rails or a pluralize method on string
  if ''.respond_to?(:pluralize)
    def smart_pluralize
      amt, word = self.extract(/[^0-9\-]*(-?[0-9,]+)?.*(?:[^a-z]|^)([a-z]+)[^a-z]*$/i)
      unless word.blank?
        word = word.pluralize if amt.blank? || amt.gsub(',','').to_i != 1
        return self.gsub(/([^a-z]|^)([a-z]+)([^a-z]*)$/i, '\1'+word+'\3')
      end
      return self
    end
  end

  # Someday will be part of core ruby, with luck...
  unless ''.respond_to?(:starts_with?)
    # Does the string start with the specified +prefix+?
    def starts_with?(prefix)
      prefix = prefix.to_s
      self[0, prefix.length] == prefix
    end

    # Does the string end with the specified +suffix+?
    def ends_with?(suffix)
      suffix = suffix.to_s
      self[-suffix.length, suffix.length] == suffix
    end
  end

  # In case we're running in Rails, which defines this already...
  unless ''.respond_to?(:constantize)
    def constantize
      names = self.split('::')
      names.shift if names.empty? || names.first.empty?

      constant = Object
      names.each do |name|
        constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
      end
      constant
    end
  end

  # When true, is a valid integer
  def integer?
    self.to_i.to_s == self
  end

end
