class PFGridViewDemoViewController < UIViewController

  def viewDidLoad
    super
    @demoGridView = PFGridView.alloc.initWithFrame(self.view.bounds)
    @demoGridView.dataSource = self
    @demoGridView.delegate = self
    @demoGridView.cellHeight = 106
    @demoGridView.headerHeight = 0
    self.view.addSubview @demoGridView

    @shots = []
    @shots.clear

    Dispatch::Queue.concurrent.async do 
      error_ptr = Pointer.new(:object)
      data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString("http://api.dribbble.com/shots/everyone?page=1&per_page=30"), options:NSDataReadingUncached, error:error_ptr)
      unless data
        presentError error_ptr[0]
        return
      end
      json = NSJSONSerialization.JSONObjectWithData(data, options:0, error:error_ptr)
      unless json
        presentError error_ptr[0]
        return
      end

      Dispatch::Queue.main.sync do
        new_shots = []
        json['shots'].each do |shot|
          new_shots << Shot.new(shot)
        end
        @shots = new_shots.each_slice(4).to_a
        @demoGridView.reloadData 
      end
    end

  end

  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    true
  end

  def didRotateFromInterfaceOrientation(fromInterfaceOrientation)
    @demoGridView.reloadData
  end

  def numberOfSectionsInGridView(gridView)
    1
  end

  def widthForSection(section)
    @demoGridView.frame.size.width
  end

  def numberOfRowsInGridView(gridView)
    @shots.length
  end

  def gridView(gridView, numberOfColsInSection: section)
    3
  end

  def gridView(gridView, widthForColAtIndexPath:indexPath)
    106
  end

  def backgroundColorForIndexPath(indexPath)
    UIColor.whiteColor
  end

  def gridView(gridView, cellForColAtIndexPath: indexPath)
    unless shot = @shots[indexPath.row][indexPath.col]
      cell = gridView.dequeueReusableCellWithIdentifier("Cell") || PFGridViewImageCell.alloc.initWithReuseIdentifier("Cell")
      cell.imageView.image = nil
      return cell
    end
    PFGridViewImageCell.cellForShot(shot, inGridView:gridView)
  end

  def headerBackgroundColorForIndexPath(indexPath)
    UIColor.whiteColor
  end

  def gridView(gridView, headerForColAtIndexPath:indexPath)
    gridCell = gridView.dequeueReusableCellWithIdentifier("HEADER") || PFGridViewCell.alloc.initWithReuseIdentifier("HEADER")
    gridCell
  end

  def viewForZoomingInScrollView(scrollView)
    @imageView
  end

  def gridView(gridView, didSelectCellAtIndexPath:indexPath)
    cellView = gridView.cellForColAtIndexPath(indexPath)
    return unless cellView.imageView.image
    frame = cellView.frame
    frame.origin.y -= cellView.superview.contentOffset.y
    @imageView = UIImageView.alloc.init
    @imageView.image = cellView.imageView.image
    cellView.imageView.hidden = true

    scrollView = UIScrollView.alloc.initWithFrame(self.view.frame)
    scrollView.delegate = self

    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 6.0

    view = UIView.alloc.initWithFrame(self.view.frame)
    view.backgroundColor = UIColor.blackColor
    view.alpha = 0

    scrollView.addSubview(@imageView)
    @imageView.frame = @imageView.superview.convertRect(frame, toView: nil)

    @imageView.whenTapped do
      scrollView.setZoomScale(1.0, animated: false)
      UIView.animateWithDuration(0.5,
        delay: 0, 
        options: UIViewAnimationOptionCurveEaseOut,
        animations: lambda {
          view.alpha = 0
          @imageView.frame = frame
        },
        completion: lambda { |finished|
          view.removeFromSuperview
          scrollView.removeFromSuperview
          cellView.imageView.hidden = false
      })
    end

    cellView.superview.superview.superview.superview.addSubview(view)
    cellView.superview.superview.superview.superview.addSubview(scrollView)

    UIView.animateWithDuration(0.5,
      animations: lambda {
        view.alpha = 1.0
        @imageView.frame = [[(self.view.frame.size.width/2) - (300/2),
          (self.view.frame.size.height/2) - (300/2)],[300,300]]
      })
    
  end

end