class MCTableViewController < UITableViewController

  stylesheet :main
  def layoutDidLoad
    layout tableView
  end

  def viewDidLoad
    super
    tableView.dataSource = tableView.delegate = self

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
        @shots = new_shots
        tableView.reloadData 
      end
    end
  end

  def tableView(tableView, didSelectRowAtIndexPath:index)
    navigationController.pushViewController(MCShotViewController.alloc.initWithShot(@shots[index.row]), animated: true)
  end
  
  def tableView(tableView, numberOfRowsInSection:number)
    @shots.length
  end

  def tableView(tableView, cellForRowAtIndexPath:index)
    shot = @shots[index.row]
    MCTableViewCell.cellForShot(shot, inTableView:tableView)
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def reloadRowForShot(shot)
    row = @shots.index(shot)
    if row
      view.reloadRowsAtIndexPaths([NSIndexPath.indexPathForRow(row, inSection:0)], withRowAnimation:false)
    end
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    60
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    autorotateToOrientation(orientation)
  end

end