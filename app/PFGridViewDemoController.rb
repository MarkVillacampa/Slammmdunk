class PFGridViewDemoViewController < UIViewController

attr_accessor :popoverController

def viewDidLoad
    super

    # @barButtonItem = navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Push", style:UIBarButtonItemStylePlain, target:self, action:"showPopover")
    @barButtonItem = navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithImage(UIImage.imageNamed("Toolbar-Icon.png"), style:UIBarButtonItemStylePlain, target:self, action:"showPopover")
    @barButtonItem.tintColor = "#ea4c89".uicolor

    self.view.backgroundColor = UIColor.blackColor
    @demoGridView = PFGridView.alloc.initWithFrame([[0,0],[320,416]])
    @demoGridView.dataSource = self
    @demoGridView.delegate = self
    @demoGridView.cellHeight = 106
    @demoGridView.headerHeight = 0
    self.view.addSubview @demoGridView

    @shots = []
    @shots.clear

    Dispatch::Queue.concurrent.async do 
      error_ptr = Pointer.new(:object)
      data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString("http://api.dribbble.com/shots/popular?page=1&per_page=28"), options:NSDataReadingUncached, error:error_ptr)
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

  def showPopover
    if not self.popoverController
      contentViewController = WEPopoverContentViewController.alloc.initWithStyle UITableViewStylePlain

      self.popoverController = WEPopoverController.alloc.initWithContentViewController(contentViewController)
      self.popoverController.delegate = self
      self.popoverController.passthroughViews = [self.navigationController.navigationBar]
      self.popoverController.containerViewProperties = self.improvedContainerViewProperties
      self.popoverController.presentPopoverFromBarButtonItem(@barButtonItem,
                     permittedArrowDirections:(UIPopoverArrowDirectionUp),
                             animated: true)

    else
      self.popoverController.dismissPopoverAnimated(true)
      self.popoverController = nil
    end
  end

  def improvedContainerViewProperties
  
    props = WEPopoverContainerViewProperties.alloc.init
    bgImageName = nil
    bgMargin = 0.0
    bgCapSize = 0.0
    contentMargin = 4.0
    
    bgImageName = "popoverBg.png"
    
    # These constants are determined by the popoverBg.png image file and are image dependent
    bgMargin = 13 # margin width of 13 pixels on all sides popoverBg.png (62 pixels wide - 36 pixel background) / 2 == 26 / 2 == 13 
    bgCapSize = 31; # ImageSize/2  == 62 / 2 == 31 pixels
    
    props.leftBgMargin = bgMargin
    props.rightBgMargin = bgMargin
    props.topBgMargin = bgMargin
    props.bottomBgMargin = bgMargin
    props.leftBgCapSize = bgCapSize
    props.topBgCapSize = bgCapSize
    props.bgImageName = bgImageName
    props.leftContentMargin = contentMargin
    props.rightContentMargin = contentMargin - 1 # Need to shift one pixel for border to look correct
    props.topContentMargin = contentMargin;
    props.bottomContentMargin = contentMargin
    
    props.arrowMargin = 4.0
    
    props.upArrowImageName = "popoverArrowUp.png"
    props.downArrowImageName = "popoverArrowDown.png"
    props.leftArrowImageName = "popoverArrowLeft.png"
    props.rightArrowImageName = "popoverArrowRight.png"
    return props
  end

  def popoverControllerDidDismissPopover thePopoverController
    # Safe to release the popover here
    self.popoverController = nil
  end

  def popoverControllerShouldDismissPopover(thePopoverController)
  # The popover is automatically dismissed if you click outside it, unless you return NO here
    true
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

  def gridView(gridView, didSelectCellAtIndexPath:indexPath)
    cellView = gridView.cellForColAtIndexPath(indexPath)
    return unless cellView.imageView.image
    @shotZoomViewController = MCShotZoomViewController.alloc.initWithCellView(cellView)
    cellView.superview.superview.superview.superview.superview.superview.superview.superview.addSubview(@shotZoomViewController.view)
  end
end