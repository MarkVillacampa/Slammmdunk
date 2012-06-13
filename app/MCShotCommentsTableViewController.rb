class MCShotCommentsTableViewController < UITableViewController

  stylesheet :main

  attr_accessor :shot

  def self.initWithShot(shot)
    tableViewController = MCShotCommentsTableViewController.alloc.init
    tableViewController.fillWithComment shot
    tableViewController
  end

  def layoutDidLoad
    layout tableView
    # always set tableHeaderView after having set it size, otherwise a height = 0 will be implied
    self.tableView.tableHeaderView = UIView.alloc.initWithFrame([[0,0],[320,44]])
    self.tableView.tableHeaderView.backgroundColor = "#F3F3F3".uicolor

    commentsButton = UIImageView.alloc.initWithImage(UIImage.imageNamed("info_button.png"))
    commentsButton.frame = [[320 - 26 -10,10],[26,26]]

    commentsButton.whenTapped do
      dismissViewControllerAnimated(true, completion: lambda {})
    end

    self.tableView.tableHeaderView.addSubview(commentsButton)
  end

  def viewDidLoad
    super
    tableView.dataSource = tableView.delegate = self
  end

  def fillWithComment(shot)
    @comments = []
    @comments.clear

    Dispatch::Queue.concurrent.async do 
      error_ptr = Pointer.new(:object)
      data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString("http://api.dribbble.com/shots/#{shot.data['id']}/comments"), options:NSDataReadingUncached, error:error_ptr)
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
        new_comments = []
        json['comments'].each do |comment|
          new_comments << Comment.new(comment)
        end
        @comments = new_comments
        tableView.reloadData 
      end
    end
  end
  
  def tableView(tableView, numberOfRowsInSection:number)
    @comments.length
  end

  def tableView(tableView, cellForRowAtIndexPath:index)
    comment = @comments[index.row]
    MCShotCommentsTableViewCell.cellForComment(comment, inTableView:tableView)
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def reloadRowForComment(comment)
    row = @comments.index(comment)
    if row
      view.reloadRowsAtIndexPaths([NSIndexPath.indexPathForRow(row, inSection:0)], withRowAnimation:false)
    end
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    MCShotCommentsTableViewCell.heightForCell(@comments[indexPath.row], tableView.frame.size.width)
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    autorotateToOrientation(orientation)
  end

end