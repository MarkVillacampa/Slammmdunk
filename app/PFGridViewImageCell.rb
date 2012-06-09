class PFGridViewImageCell < PFGridViewCell

  def initWithReuseIdentifier(reuseIdentifier)
    super(reuseIdentifier)
    @stylesheet = :main
    layout (self) {
      @imageView = subview(UIImageView, :frame => [[0,0],[80,80]],
                                        :image => nil)
    }
    self
  end

  def self.cellForShot(shot, inGridView:gridView)
    cell = gridView.dequeueReusableCellWithIdentifier("Cell") || PFGridViewImageCell.alloc.initWithReuseIdentifier("Cell")
    cell.fillWithShot(shot, inGridView:gridView)
    cell
  end

  def fillWithShot(shot, inGridView:gridView)
    unless shot.image_small
      @imageView.image = nil
      Dispatch::Queue.concurrent.async do
        image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(shot.data['image_teaser_url']))
        if image_data
          shot.image_small = UIImage.alloc.initWithData(image_data)
          Dispatch::Queue.main.sync do
            @imageView.image = shot.image_small
            #gridView.reloadData
          end
        end
      end
    else
      @imageView.image = shot.image_small
    end
  end
end