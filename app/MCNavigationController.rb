class MCNavigationController < UINavigationController

  stylesheet :main
  def layoutDidLoad
    layout navigationBar, :top_bar {
      subview(UIView, { :backgroundColor => "#ffffff".uicolor(0.5), :opaque => true, :frame => [[0,navigationBar.frame.size.height-1], [navigationBar.frame.size.width, 1]] })
    }
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    autorotateToOrientation(orientation)
  end

end