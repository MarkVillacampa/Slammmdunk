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

  style UITableViewCell,
    accessoryType: UITableViewCellAccessoryDisclosureIndicator

  style :cell_label,
    textColor: "#595857".uicolor,
    landscape: true

  style :image_view,
    frame: [[5, 5], [49, 49]],
    landscape: true,
    layer: {
      masksToBounds: true,
      cornerRadius: 10.0,
      borderColor: "#595857".uicolor.CGColor,
      borderWidth: 1.0
    }

end