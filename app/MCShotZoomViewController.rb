class MCShotZoomViewController < UIViewController

  def viewForZoomingInScrollView(scrollView)
    @imageView
  end

  def scrollViewDidZoom(scrollView)
    innerFrame = @imageView.frame
    scrollerBounds = scrollView.bounds

    if ( innerFrame.size.width < scrollerBounds.size.width ) || ( innerFrame.size.height < scrollerBounds.size.height )
        tempx = @imageView.center.x - ( scrollerBounds.size.width / 2 )
        tempy = @imageView.center.y - ( scrollerBounds.size.height / 2 )
        myScrollViewOffset = CGPointMake( tempx, tempy)

        scrollView.contentOffset = myScrollViewOffset
    end

    anEdgeInset = UIEdgeInsetsMake(0, 0, 0, 0)
    if scrollerBounds.size.width > innerFrame.size.width
      anEdgeInset.left = (scrollerBounds.size.width - innerFrame.size.width) / 2
      anEdgeInset.right = -anEdgeInset.left  # I don't know why this needs to be negative, but that's what works
    end
    if scrollerBounds.size.height > innerFrame.size.height
        anEdgeInset.top = (scrollerBounds.size.height - innerFrame.size.height) / 2
        anEdgeInset.bottom = -anEdgeInset.top;  # I don't know why this needs to be negative, but that's what works
    end
    scrollView.contentInset = anEdgeInset
  end

  def initWithCellView(cellView)
    self.view.frame = [[0,0],[320,480]]
    frame = cellView.frame
    # statusBar (20) + navigationBar (44) height
    frame.origin.y += 64
    # substract scrollView content offset
    frame.origin.y -= cellView.superview.contentOffset.y

    @imageView = UIImageView.alloc.init
    @imageView.image = cellView.imageView.image
    cellView.imageView.hidden = true

    scrollView = UIScrollView.alloc.initWithFrame([[0,0],[320,480]])
    scrollView.delegate = self
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 3.0

    blackView = UIView.alloc.initWithFrame([[0,0],[320,480]])
    blackView.backgroundColor = UIColor.blackColor
    blackView.alpha = 0

    commentsButton = UIImageView.alloc.initWithImage(UIImage.imageNamed("info_button.png"))
    commentsButton.frame = [[320 - 26 -10,10],[26,26]]

    commentsButton.whenTapped do
      commentsViewController = MCShotCommentsTableViewController.initWithShot(cellView.shot)
      commentsViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal
      self.presentViewController(commentsViewController, animated: true, completion: lambda {})
    end

    @imageView.frame = frame

    scrollView.addSubview(@imageView)

    self.view.addSubview(blackView)
    self.view.addSubview(scrollView)
    self.view.addSubview(commentsButton)

    UIApplication.sharedApplication.setStatusBarHidden(true, animated:true)
    
    UIView.animateWithDuration(0.5,
      delay: 0,
      options: UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionNone,
      animations: lambda {
        blackView.alpha = 1.0
        # @imageView.frame = [[(self.view.bounds.size.width/2) - (300/2),
          # (self.view.bounds.size.height/2) - (300/2)],[300,300]]
        @imageView.frame = [[0,(480 - 320)/2],[320,320]]
      },
      completion: lambda { |finished|
        @imageView.frame = [[0,0],[320,320]]
        scrollViewDidZoom(scrollView)
      })
    
    @imageView.whenTapped do
      UIApplication.sharedApplication.setStatusBarHidden(false, animated:true)
      scrollView.setZoomScale(1.0, animated: true)
      @imageView.frame.origin.y = (480 - 320)/2
      commentsButton.removeFromSuperview
      UIView.animateWithDuration(0.5,
        delay: 0, 
        options: UIViewAnimationOptionCurveEaseOut,
        animations: lambda {
          blackView.alpha = 0
          frame.origin.y -= 80
          @imageView.frame = frame
        },
        completion: lambda { |finished|
          self.view.removeFromSuperview
          cellView.imageView.hidden = false
      })
    end

    self
  end

end