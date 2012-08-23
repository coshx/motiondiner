class WelcomeViewController < UIViewController

  # loadView is called before anything is displayed - this is where we should allocate instance vars and such
  def loadView
    self.view = UIView.alloc.init
    self.title = "MotionDiner"
    # set background color to a nice steel blue
    self.view.backgroundColor = AppConstants.defaultBackgroundColor
  end

  # viewDidLoad is called when this viewController's main view is actually shown, so here is where we can make this actually get displayed
  def viewDidLoad
    # adding the two buttons
    @dinerButton = makeDinerButton
    @truckButton = makeTruckButton

    view.addSubview(@dinerButton)
    view.addSubview(@truckButton)
  end

  # called when diner button is activated
  def dinerSelected
    dinerViewController = DinerViewController.alloc.init
    self.parentViewController.pushViewController(dinerViewController, animated: true)
  end

  # called when truck button is activated
  def truckSelected
    truckViewController = TruckViewController.alloc.init
    self.parentViewController.pushViewController(truckViewController, animated: true)
  end

  def makeDinerButton    
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.addTarget(self, action: "dinerSelected", forControlEvents: UIControlEventTouchUpInside)
    button.setTitle("I'm a diner", forState: UIControlStateNormal)

    #buttonFrame = CGRectMake(10, 60, 300, 80)
    buttonFrame = [[10,120], [300, 60]] # origin, size
    button.frame = buttonFrame
    
    button
  end

  def makeTruckButton
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.addTarget(self, action: "truckSelected", forControlEvents: UIControlEventTouchUpInside)
    button.setTitle("I'm a truck", forState: UIControlStateNormal)

    #buttonFrame = CGRectMake(10, 60, 300, 80)
    buttonFrame = [[10,200], [300, 60]] # origin, size
    button.frame = buttonFrame
    
    button
  end

end