class WEPopoverContentViewController < UITableViewController

  attr_accessor :gridView, :popover

  def init(style, gridView)
    view = WEPopoverContentViewController.alloc.initWithStyle(style)
    view.gridView = gridView
    view.contentSizeForViewInPopover = CGSizeMake(285, 3 * 44)
    view
  end

  def viewDidLoad
    super
    self.tableView.rowHeight = 44.0
    self.tableView.bounces = false
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone
    self.tableView.backgroundColor = UIColor.clearColor

    @data = ['Popular', 'Debuts', 'Everyone']
  end

  def numberOfSectionsInTableView tableView
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    3
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier("Cell") || PopoverCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:"Cell")
    cell.selectionStyle = UITableViewCellSelectionStyleNone
    cell.backgroundColor = UIColor.clearColor
    cell.textLabel.text = @data[indexPath.row]
    cell.textLabel.textColor = UIColor.whiteColor
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    self.gridView.loadGridData(@data[indexPath.row].downcase)
    self.popover.dismissPopoverAnimated(true)
    self.gridView.popoverController = nil
  end

  def tableView(tableView, willDisplayCell:cell, forRowAtIndexPath:indexPath)
    cell.setBackgroundColor UIColor.clearColor
  end
end