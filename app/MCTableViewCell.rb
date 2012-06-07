class MCTableViewCell < UITableViewCell

  def self.cellForShot(shot, inTableView:tableView)
    cell = tableView.dequeueReusableCellWithIdentifier("Cell") || MCTableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:"Cell")
    cell.fillWithShot(shot, inTableView:tableView)
    cell
  end

  def fillWithShot(shot, inTableView:tableView)
    self.textLabel.text = shot.data['title']

    unless shot.image_small
      self.imageView.image = nil
      Dispatch::Queue.concurrent.async do
        image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(shot.data['image_teaser_url']))
        if image_data
          shot.image_small = UIImage.alloc.initWithData(image_data)
          Dispatch::Queue.main.sync do
            self.imageView.image = shot.image_small
            tableView.delegate.reloadRowForShot(shot)
          end
        end
      end
    else
      self.imageView.image = shot.image_small
    end
  end

  def layoutSubviews
    super #always call super in layoutSubviews
    @stylesheet = :main
    layout self
    layout imageView, :image_view
    label_size = self.frame.size
    layout textLabel, :cell_label, { :frame => [[65, 0], [label_size.width - 95, label_size.height - 1]] }
  end
end