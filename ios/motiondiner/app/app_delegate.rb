class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    # need to make the Window an instance var to prevent premature garbage collection
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    welcomeViewController = WelcomeViewController.alloc.init
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(welcomeViewController)
    @window.makeKeyAndVisible
    true
  end
end
