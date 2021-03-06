class WelcomeViewController < UIViewController

  # loadView is called before anything is displayed - this is where we should allocate instance vars and such
  def loadView
    self.view = UIView.alloc.init
    self.title = "MotionDiner"
    # set background color to a nice steel blue
    self.view.backgroundColor = AppConstants.defaultBackgroundColor

    # now let's add the 'share' button to the top-right
    shareButton = UIBarButtonItem.alloc.initWithTitle("Share", style:UIBarButtonItemStylePlain, target:self, action:"share")
    # notice that we just used a string as the selector name - this is a nice convenience thing RubyMotion lets us do, normally we'd need to make sure we passed in a selector, not just a string
    self.navigationItem.rightBarButtonItem = shareButton

    # need the segmented control to display in the toolbar
    # making an instance variable so we can access it elsewhere
    @segmentedBar = UISegmentedControl.alloc.initWithItems(["I Want Food", "I Am a Truck"])
    @segmentedBar.addTarget(self, action:"segmentSelected", forControlEvents:UIControlEventValueChanged)
    @segmentedBar.momentary = true # don't keep the sides 'pressed' when tapped
    @segmentedBar.segmentedControlStyle = UISegmentedControlStyleBar # otherwise it's waaaay too large

    # add in the buttons for the toolbar at the bottom
    self.toolbarItems = []
    # need spacers around buttons to keep them from just sitting on the left
    self.toolbarItems << UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action: nil)
    self.toolbarItems << UIBarButtonItem.alloc.initWithCustomView(@segmentedBar)
    self.toolbarItems << UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action: nil)
  end

  # viewDidLoad is called when this viewController's main view is actually shown, so here is where we can make this actually get displayed
  def viewDidLoad
    # show the toolbar
    self.parentViewController.setToolbarHidden(false, animated:false)
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

  def share
    services = ["Facebook", "Twitter", "LinkedIn", "Pinterest", "LiveJournal"]
    App.alert("Thanks for spamming your #{services.shuffle.first} friends with our app!")
  end

  def segmentSelected
    puts "segmentSelected"
    puts @segmentedBar
    if @segmentedBar.selectedSegmentIndex == 0
      dinerSelected
    else
      truckSelected
    end
  end

end