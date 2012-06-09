class MCTableViewCell < UITableViewCell

  def initWithStyle(style, reuseIdentifier: identifier)
    super
    @stylesheet = :main
    layout(contentView){
      subview(UIImageView, { :image => UIImage.imageNamed("camera.png"),
                             :frame => [[65, 35],[14, 14]] })

      @views_label = subview(UILabel, { :font => UIFont.systemFontOfSize(14), 
                                        :textColor => "#595857".uicolor, 
                                        :frame => [[86, 35],[40, 16]],
                                        :backgroundColor => UIColor.clearColor
                                      })
      subview(UIImageView, { :image => UIImage.imageNamed("speech_bubble.png"),
                             :frame => [[126, 35],[14, 14]] })

      @comments_label = subview(UILabel, { :font => UIFont.systemFontOfSize(14), 
                                        :textColor => "#595857".uicolor, 
                                        :frame => [[147, 35],[40, 16]],
                                        :backgroundColor => UIColor.clearColor
                                      })
      subview(UIImageView, { :image => UIImage.imageNamed("heart.png"),
                             :frame => [[187, 35],[14, 14]] })

      @likes_label = subview(UILabel, { :font => UIFont.systemFontOfSize(14), 
                                        :textColor => "#595857".uicolor, 
                                        :frame => [[208, 35],[40, 16]],
                                        :backgroundColor => UIColor.clearColor
                                      })
    }
    self
  end

  def self.cellForShot(shot, inTableView:tableView)
    cell = tableView.dequeueReusableCellWithIdentifier("Cell") || MCTableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:"Cell")
    cell.fillWithShot(shot, inTableView:tableView)
    cell
  end

  def fillWithShot(shot, inTableView:tableView)
    self.textLabel.text = shot.data['title']
    @views_label.text = shot.data['views_count'].to_s
    @comments_label.text = shot.data['comments_count'].to_s
    @likes_label.text = shot.data['likes_count'].to_s

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
    layout self
    layout imageView, :image_view

    layout textLabel, :cell_label, { :frame => [[65, 4], [self.frame.size.width - 95, 30]], :backgroundColor => UIColor.clearColor }
  end

end