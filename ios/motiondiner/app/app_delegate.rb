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
    takeOffOptions.setValue(launchOptions, forKey:UAirshipTakeOffOptionsLaunchOptionsKey)
    UAirship.takeOff(takeOffOptions)
    # NSMutableDictionary *takeOffOptions = [[[NSMutableDictionary alloc] init] autorelease];
    # [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
     
    # // Create Airship singleton that's used to talk to Urban Airship servers.
    # // Please populate AirshipConfig.plist with your info from http://go.urbanairship.com
    # [UAirship takeOff:takeOffOptions];

    # now actually register for notifications    
    UAPush.shared.registerForRemoteNotificationTypes(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)
# [[UAPush shared]
#  registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
#                                      UIRemoteNotificationTypeSound |
#                                      UIRemoteNotificationTypeAlert)];
    true
  end

  def applicationWillTerminate(application)
    UAirship.land
  end

  def application(application, didRegisterForRemoteNotificationsWithDeviceToken:deviceToken)
    deviceTokenDescription = deviceToken.description
    p "User registered for remote notifications with device token: #{deviceTokenDescription}"

    # Urban Airship registration - Updates the device token and registers the token with UA
    UAPush.shared.registerDeviceToken(deviceToken)
    #[[UAPush shared] registerDeviceToken:deviceToken];
  end

  def application(application, didFailToRegisterForRemoteNotificationsWithError:error)
    errorMessage = NSString.alloc.initWithFormat("Error in registering for notifications: %@", error)
    p errorMessage
  end

  def requestNotificaitonPermissions
    notificationTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert
    app = UIApplication.sharedApplication
    app.registerForRemoteNotificationTypes(notificationTypes)
  end
end
