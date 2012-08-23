class DinerViewController < UIViewController

  def loadView
    self.view = UIView.alloc.init
    self.title = "Find a Truck"
    # set background color to a nice steel blue
    self.view.backgroundColor = AppConstants.defaultBackgroundColor
  end

  def viewDidLoad    
    labelFrame = [[10,200], [300, 80]] # origin, size
    label = UILabel.alloc.initWithFrame(labelFrame)
    label.text = "U R DINER WOO"
    label.backgroundColor = UIColor.lightGrayColor
    label.font = UIFont.boldSystemFontOfSize(28)
    label.textAlignment = UITextAlignmentCenter
    view.addSubview(label)
  end

end