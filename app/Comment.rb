class Comment
  attr_reader :data
  attr_accessor :avatar

  def initialize(comment)
    @data = comment
    @avatar = nil
  end
end