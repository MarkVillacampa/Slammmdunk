class PFGridViewImageCell < PFGridViewCell

  attr_accessor :imageView, :shot

  def initWithReuseIdentifier(reuseIdentifier)
    super(reuseIdentifier)
    @stylesheet = :main
    layout (self) {
      @imageView = subview(UIImageView, :frame => [[0,0],[106,79.5]],
                                        :image => nil)
    }
    self.selectedBackgroundColor = UIColor.blackColor
    self.normalBackgroundColor = UIColor.blackColor

    self
  end

  def self.cellForShot(shot, inGridView:gridView)
    cell = gridView.dequeueReusableCellWithIdentifier("Cell") || PFGridViewImageCell.alloc.initWithReuseIdentifier("Cell")
    cell.fillWithShot(shot, inGridView:gridView)
    cell.shot = shot
    cell
  end

  def fillWithShot(shot, inGridView:gridView)
    unless shot.image_small
      @activityIndicator = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhite)
      @activityIndicator.startAnimating
      self.addSubview(@activityIndicator)
      @imageView.image = nil
      Dispatch::Queue.concurrent.async do
        image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(shot.data['image_teaser_url']))
        if image_data
          shot.image_small = UIImage.alloc.initWithData(image_data)
          Dispatch::Queue.main.sync do
            @activityIndicator.removeFromSuperview
            @imageView.image = shot.image_small
            animate
            #gridView.reloadData
          end
        end
      end
    else
      @imageView.image = shot.image_small
    end
  end 

  # placing this inside `Dispatch::Queue.concurrent.sync` caused a silent crash...
  def animate
    @imageView.alpha = 0
    UIView.animateWithDuration(0.2, animations: lambda {
      @imageView.alpha =1 
      }, completion: nil)
  end
end