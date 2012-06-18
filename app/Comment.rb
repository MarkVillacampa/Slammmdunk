class Comment
  attr_accessor :avatar, :data

  def initialize(comment)
    @data = comment.dup
    @avatar = nil
    format_comment
  end

  def format_comment
    comment_text = @data['body'].dup
    @data['body'] = NIAttributedLabel.alloc.initWithFrame(CGRectZero)

    @links = Hash.new
    comment_text.gsub!(Regexp.new("<a href=\"([a-zA-Z0-9_:/!?.%#-&;=]+)\">([a-zA-Z0-9_@\. \t\n\r\f]+)</a>")) { |match|
      @links[$2.to_s] = $1.to_s
      $2.to_s
    }

    @strong = []
    comment_text.gsub!(Regexp.new("<strong>([^<]+)</strong>")) { |match|
      @strong << $1.to_s
      $1.to_s
    }

    @italic = []
    comment_text.gsub!(Regexp.new("<em>([^<]+)</em>")) { |match|
      @italic << $1.to_s
      $1.to_s
    }

    @data['body'].text = comment_text

    @data['body'].setFont(UIFont.systemFontOfSize(14), range: NSMakeRange(0, @data['body'].text.length))

    @links.each do |key, value|
      @data['body'].addLink(NSURL.URLWithString(value), range: comment_text.rangeOfString(key))
    end

    @italic.each do |value|
       @data['body'].setFont(UIFont.italicSystemFontOfSize(14), range: @data['body'].text.rangeOfString(value))
    end

    @strong.each do |value|
       @data['body'].setFont(UIFont.boldSystemFontOfSize(14), range: @data['body'].text.rangeOfString(value))
    end
  end
end