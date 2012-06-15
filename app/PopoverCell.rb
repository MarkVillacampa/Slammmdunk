class PopoverCell < UITableViewCell

  def setHighlighted(highlighted, animated:animated)
    super
    self.backgroundColor = "#ea4c89".uicolor
  end

end