class PFGridViewDemoViewController < UIViewController

  def viewDidLoad
    super
    @demoGridView = PFGridView.alloc.initWithFrame(self.view.bounds)
    @demoGridView.dataSource = self
    @demoGridView.delegate = self
    @demoGridView.cellHeight = 80
    @demoGridView.headerHeight = 44
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
    4
  end

  def gridView(gridView, widthForColAtIndexPath:indexPath)
    80
  end

  def backgroundColorForIndexPath(indexPath)
    UIColor.whiteColor
  end

  def gridView(gridView, cellForColAtIndexPath: indexPath)
    unless shot = @shots[indexPath.row][indexPath.col]
      return cell = gridView.dequeueReusableCellWithIdentifier("EmptyCell") || PFGridViewCell.alloc.initWithReuseIdentifier("EmptyCell")
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

  def gridView(gridView, didSelectCellAtIndexPath:index)
    navigationController.pushViewController(MCShotViewController.alloc.initWithShot(@shots[index.row][index.col]), animated: true)
  end

end