class MCNavigationController < UINavigationController

  stylesheet :main
  def layoutDidLoad
    layout navigationBar, :top_bar {
      subview(UIView, { :backgroundColor => "#2E2E2E".uicolor, :opaque => true, :frame => [[0,navigationBar.frame.size.height-2], [navigationBar.frame.size.width, 2]] })
    }
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    autorotateToOrientation(orientation)
  end

end