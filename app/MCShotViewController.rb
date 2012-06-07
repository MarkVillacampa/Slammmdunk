class MCShotViewController < UIViewController

  def initWithShot(shot)
    self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemHistory, tag:2)

    @shot = shot
    self
  end

  stylesheet :main

  def layoutDidLoad
    layout view, { :backgroundColor => "#F3F3F3".uicolor } {
      @image_view = subview(UIImageView, { :frame => [[10, 64],[self.view.frame[1][0] - 20, (self.view.frame[1][0] - 20) * 3/4 ]] })
    }

    @image_view.image = @shot.image_big
    unless @shot.image_big
      Dispatch::Queue.concurrent.async do
        image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(@shot.data['image_url']))
        if image_data
          @shot.image_big = UIImage.alloc.initWithData(image_data)
          Dispatch::Queue.main.sync do
            @image_view.image = @shot.image_big
            @image_view.setNeedsDisplay
          end
        end
      end
    end
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    autorotateToOrientation(orientation)
  end

end