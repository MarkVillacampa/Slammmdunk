Teacup::Stylesheet.new :main do

  style UINavigationBar,
    barStyle: UIBarStyleBlack,
    tintColor: "#ea4c89".uicolor,
    translucent: false,
    landscape: {
      tintColor: UIColor.blackColor
    }

  style UITableView,
    backgroundColor: "#F3F3F3".uicolor,
    separatorColor: "#eaeaea".uicolor,
    landscape: true

  style :cell_label,
    textColor: "#595857".uicolor,
    landscape: true,
    backgroundColor: UIColor.clearColor

  style(:image_view,
    frame: [[6, 6], [49 , 49]],
    landscape: true,
    layer: {
      masksToBounds: true,
      cornerRadius: 10.0,
      borderColor: "#595857".uicolor.CGColor,
      borderWidth: 1.0
    })

  style :comment_label,
    numberOfLines: 0,
    # font: UIFont.systemFontOfSize(14),
    backgroundColor: UIColor.clearColor

  style :time_label,
    # font: UIFont.systemFontOfSize(10),
    backgroundColor: UIColor.clearColor,
    textColor: UIColor.lightGrayColor

end