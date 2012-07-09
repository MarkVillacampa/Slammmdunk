class MCShotCommentsTableViewController < UITableViewController

  stylesheet :main

  attr_accessor :shot

  def self.initWithShot(shot)
    tableViewController = MCShotCommentsTableViewController.alloc.init
    tableViewController.shot = shot
    tableViewController
  end

  def layoutDidLoad
    layout tableView
    # always set tableHeaderView after having set it size, otherwise a height = 0 will be implied
    self.tableView.tableHeaderView = UIView.alloc.initWithFrame([[0,0],[320,44]])
    self.tableView.tableHeaderView.backgroundColor = "#F3F3F3".uicolor

    commentsButton = UIImageView.alloc.initWithImage(UIImage.imageNamed("info_button.png"))
    commentsButton.frame = [[320 - 26 -10,10],[26,26]]

    commentsButton.setUserInteractionEnabled true

    singleTapGestureRecognizer = UITapGestureRecognizer.alloc.initWithTarget( @block_three = Proc.new {
      dismissViewControllerAnimated(true, completion: lambda {})
      }, action: 'call')
    
    singleTapGestureRecognizer.numberOfTapsRequired = 1
    commentsButton.addGestureRecognizer(singleTapGestureRecognizer)

    self.tableView.tableHeaderView.addSubview(commentsButton)
  end

  def viewDidLoad
    super
    tableView.dataSource = tableView.delegate = self

    self.tableView.addPullToRefreshWithActionHandler lambda {
      @shot.page = 1
      loadComments(1, overide: true)
    }
    
    self.tableView.addInfiniteScrollingWithActionHandler lambda {
      loadComments(@shot.page+1, overide: false)
    }

    if @shot.comments.length == 0
      loadComments(1, overide: true)
    end
  end

  def loadComments(page, overide: overide)
    #you cant pass a local variable into a dispatch block!
    @page_temp = page
    @shot.page = page
    puts page
    Dispatch::Queue.concurrent.async do 
      error_ptr = Pointer.new(:object)
      data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString("http://api.dribbble.com/shots/#{shot.data['id']}/comments?page=#{@page_temp}&per_page=30"), options:NSDataReadingUncached, error:error_ptr)
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
        @total_pages = json['pages']
        puts @total_pages
        if @total_pages == @page_temp
          self.tableView.tableFooterView = nil
          puts "disabled"
        end
        json['comments'].each do |comment|
          new_comments << Comment.new(comment)
        end
        if overide
          @shot.comments = new_comments
        else
          new_comments.each do |comment|
            @shot.comments << comment
          end
        end
        tableView.reloadData
        tableView.pullToRefreshView.stopAnimating
      end
    end
  end

  def tableView(tableView, numberOfRowsInSection:number)
    @shot.comments.length
  end

  def tableView(tableView, cellForRowAtIndexPath:index)
    comment = @shot.comments[index.row]
    MCShotCommentsTableViewCell.cellForComment(comment, inTableView:tableView)
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def reloadRowForComment(comment)
    row = @shot.comments.index(comment)
    if row
      view.reloadRowsAtIndexPaths([NSIndexPath.indexPathForRow(row, inSection:0)], withRowAnimation:false)
    end
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    MCShotCommentsTableViewCell.heightForCell(@shot.comments[indexPath.row], tableView.frame.size.width)
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    autorotateToOrientation(orientation)
  end
end