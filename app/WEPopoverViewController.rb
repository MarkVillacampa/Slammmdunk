class WEPopoverViewController < UIViewController

  def onButtonClick
  
  # if (self.popoverController) {
  #   [self.popoverController dismissPopoverAnimated:YES];
  #   self.popoverController = nil;
  #   [button setTitle:@"Show Popover" forState:UIControlStateNormal];
  # } else {
  #   UIViewController *contentViewController = [[WEPopoverContentViewController alloc] initWithStyle:UITableViewStylePlain];
    
  #   self.popoverController = [[[WEPopoverController alloc] initWithContentViewController:contentViewController] autorelease];
  #   [self.popoverController presentPopoverFromRect:button.frame 
  #                       inView:self.view 
  #               permittedArrowDirections:UIPopoverArrowDirectionDown
  #                       animated:YES];
  #   [contentViewController release];
  #   [button setTitle:@"Hide Popover" forState:UIControlStateNormal];
  end
end