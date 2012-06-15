class WEPopoverContentViewController < UITableViewController

  def initWithStyle style
    super
    self.contentSizeForViewInPopover = CGSizeMake(285, 3 * 44)
    @data = ['Popular', 'Debuts', 'Everyone']
    self
  end

  def viewDidLoad
    super
    self.tableView.rowHeight = 44.0
    self.tableView.bounces = false
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone
    self.view.backgroundColor = UIColor.clearColor
    # // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
  end

  def numberOfSectionsInTableView tableView
    # Return the number of sections.
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    # Return the number of rows in the section.
    3
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier("Cell") || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:"Cell")
    cell.textLabel.text = @data[indexPath.row]
    cell.textLabel.textColor = UIColor.whiteColor
    cell
  end

#pragma mark -
#pragma mark Table view delegate

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)

  end
end