class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    # need to make the Window an instance var to prevent premature garbage collection
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    welcomeViewController = WelcomeViewController.alloc.init
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(welcomeViewController)
    @window.makeKeyAndVisible
    requestNotificaitonPermissions
    true
  end

  def application(application, didRegisterForRemoteNotificationsWithDeviceToken:deviceToken)
    deviceTokenDescription = deviceToken.description
    p "User registered for remote notifications with device token: #{deviceTokenDescription}"
    App.alert("Successfully got permission to send notifications: #{deviceTokenDescription}")
  end

  def application(application, didFailToRegisterForRemoteNotificationsWithError:error)
    errorMessage = NSString.alloc.initWithFormat("Error in registering for notifications: %@", error)
    p errorMessage
    App.alert("Failed to get push notifications: #{errorMessage}")
  end

  def requestNotificaitonPermissions
    App.alert("Going to try and request push notifications...")
    notificationTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert
    app = UIApplication.sharedApplication
    app.registerForRemoteNotificationTypes(notificationTypes)
  end
end
