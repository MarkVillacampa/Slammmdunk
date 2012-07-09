class MCShotCommentsTableViewCell < UITableViewCell

  def initWithStyle(style, reuseIdentifier: identifier)
    super
    @stylesheet = :main
    layout contentView do
      @commentLabel = subview(TTStyledTextLabel, :comment_label, { :font => UIFont.systemFontOfSize(14)})
      @timeLabel = subview(UILabel, :time_label, {font: UIFont.systemFontOfSize(10)})
    end
    # navigator = TTNavigator.navigator
    # navigator.persistenceMode = TTNavigatorPersistenceModeNone
    # navigator.delegate = self
    self
  end

  def self.cellForComment(comment, inTableView:tableView)
    cell = tableView.dequeueReusableCellWithIdentifier("Cell") || MCShotCommentsTableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:"Cell")
    cell.fillWithComment(comment, inTableView:tableView)
    cell.selectionStyle = UITableViewCellSelectionStyleNone
    cell
  end

  def fillWithComment(comment, inTableView:tableView)
    @commentLabel.text = comment.data['body']

    df = NSDateFormatter.alloc.init
    df.setDateFormat "yyyy/MM/dd HH:mm:ss '-0400'"
    myDate = df.dateFromString(comment.data['created_at'])
    calendar = NSCalendar.currentCalendar
    components = calendar.components(NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit, fromDate: myDate)

    if components.day == 0
      @timeLabel.text = "#{components.hour.to_s} hours ago"
    else
      @timeLabel.text = "#{components.day.to_s} days ago"
    end

    self.textLabel.text = comment.data['player']['name']

    unless comment.avatar
      self.imageView.image = nil
      Dispatch::Queue.concurrent.async do
        image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(comment.data['player']['avatar_url']))
        if image_data
          comment.avatar = UIImage.alloc.initWithData(image_data)
          Dispatch::Queue.main.sync do
            self.imageView.image = comment.avatar
            tableView.delegate.reloadRowForComment(comment)
          end
        end
      end
    else
      self.imageView.image = comment.avatar
    end
  end

  def self.heightForCell(comment, width)
    # constrain = [225, 1000]
    # size = comment.data['body'].sizeWithFont(UIFont.systemFontOfSize(14), constrainedToSize:constrain)
    comment.data['body'].width = 225
    comment.data['body'].font = UIFont.systemFontOfSize(14)
    # [60, size.height + 47].max
    [60, comment.data['body'].height + 47].max
  end

  def layoutSubviews
    super #always call super in layoutSubviews
    layout self
    layout imageView, :image_view
    layout textLabel, :cell_label, { :frame => [[65, 4], [self.frame.size.width - 95, 20]], 
                                     :backgroundColor => UIColor.clearColor,
                                     :font => UIFont.boldSystemFontOfSize(17),
                                     :textColor => UIColor.blackColor }
    @commentLabel.frame = [[65,40],[self.frame.size.width - 95, self.frame.size.height - 40]]
    @timeLabel.frame = [[65,24],[self.frame.size.width - 95, 15]]
  end

  def navigator(navigator, shouldOpenURL: url)
    query = url.query
    UIApplication.sharedApplication.openURL(url.absoluteURL)

    if query == nil
        return true
    else 
        return false
    end
  end
end