class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)    
    # need to make the Window an instance var to prevent premature garbage collection
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    welcomeViewController = WelcomeViewController.alloc.init
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(welcomeViewController)
    @window.makeKeyAndVisible    

    #requestNotificaitonPermissions
    # Urban Airship setup - Init Airship launch options
    takeOffOptions = NSMutableDictionary.alloc.init
    takeOffOptions.setValue( launchOptions, forKey: UAirshipTakeOffOptionsLaunchOptionsKey )
    UAirship.takeOff( takeOffOptions )

    # now actually register for notifications    
    UAPush.shared.registerForRemoteNotificationTypes( 
      UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound
    )

    true
  end

  def applicationWillTerminate(application)
    UAirship.land
  end

  def application(application, didRegisterForRemoteNotificationsWithDeviceToken:deviceToken)
    #App.alert("In application:didRegisterForRemoteNotificationsWithDeviceToken")
    # deviceTokenDescription = deviceToken.description
    # p "User registered for remote notifications with device token: #{deviceTokenDescription}"

    # Urban Airship registration - Updates the device token and registers the token with UA
    UAPush.shared.registerDeviceToken(deviceToken)
    #[[UAPush shared] registerDeviceToken:deviceToken];
  end

  def application(application, didFailToRegisterForRemoteNotificationsWithError:error)
    #App.alert("in application:didFailToRegisterForRemoteNotificationsWithError")
    errorMessage = NSString.alloc.initWithFormat("Error in registering for notifications: %@", error)
    p errorMessage
    #App.alert("Error message: #{errorMessage}")
  end

  def requestNotificaitonPermissions
    notificationTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert
    app = UIApplication.sharedApplication
    app.registerForRemoteNotificationTypes(notificationTypes)
  end
end
