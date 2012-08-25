MotionDiner
===========

Food trucks. They're all over now and they're delicious (most of the time). The problem: finding them.

It's true, there are apps out there that try to cover food trucks already, but they're really just ... not very good. The number one problem with food trucks isn't the taste or the quality or the price - it's reliably finding them. Some post a schedule on a blog (which is often wrong after plans change) or try and Tweet about where they are, but it's just not a good way to find them.

We want to change that. We want to make it easy for food truck operators to post where there are so people can find them, and then make it easy for people to get this information. It's a lovely marriage of appetite and simplicity. You find the truck, eat, and everyone is happy.

...

Of course, reality got in the way of making all of this happen in 48 hours. We focused on the truck operator side for both the server and the iOS app. Here's what we have:

* A Rails application running on Heroku with information about trucks:
  - whether they're open or not
  - the framework to let trucks post their location (not currently being done)
  - the foundation for doing some predictive work on trying to 'guess' the hours of the food trucks to create reminders heuristically

* An iPhone app written in RubyMotion that:
  - lets you pick a truck and get the status of it
  - open and close the truck
  - get push notifications on the phone via Urban Airship
  - can be deployed to testers using TestFlight

* A beautiful design. Please see images under https://github.com/coshx/motiondiner/tree/develop/app/assets/images.

The notification hookup does work and you can receive them, but the server currently doesn't send notifications. We know it works because we can manually send messages to devices that have accepted notifications (and Urban Airship has a handy tool for doing so).

...

Testing the app:

If you would like to try the app out, we need your UDID (device identifier) so that we can add you to the provisioning certificate. Apple is *very* picky about these things, even for apps that aren't out in the store yet. TestFlight makes it easy to export your device info from their site, so the easiest way for this to happen is for one of us to invite you to our TestFlight project, you register your device there (the link in the email from the phone can directly extract the UDID I believe), and then we export it and attach it to the provisioning certificate. Then you need to install the TestFlight profile onto your phone so it can authenticate with their site and install things.

After that, we just need to re-build the app with the updated certificate and deploy the build. Once that's done, you can use the TestFlight 'app' (in quotes because it's not really an app, but whatever) to select the app and install it.

We can send you push notifications if you accept them when the app starts. Otherwise... well, we can't. You're not really missing out right now, but you will be some day. ;)

There are at least three trucks right now: IDs 1, 21, and 31. You should see a reasonable error message if you use a different ID.

If you have RubyMotion you can build the app yourself and run it in the simulator (although the iOS simulator doesn't play well with Urban Airship on some architectures, be warned). If you know what you're doing certificate-wise, you can probably build the app and put it on your phone locally as well, but that's a bit beyond the scope of normal judging here.

Gil, the designer, created some lovely concept art that we desperately want to utilize in the app to make it a wonderful experience to use, but we simply didn't have the time now. Please do take a look though - he did great work and we hope to put it in peoples' hands someday.

Thanks for judging and for taking the time to get hooked up with TestFlight to try it!

---


helping the hungry masses win the game of hide and seek with the food trucks

mysql setup
===========

    mysql -u root -p

    CREATE DATABASE motion_diner_development;
    CREATE DATABASE motion_diner_test;
    CREATE USER 'motion_diner'@'localhost' IDENTIFIED BY 'password';
    GRANT SELECT, CREATE, INSERT, UPDATE, DELETE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES ON motion_diner_development.* TO 'motion_diner'@'localhost';
    GRANT SELECT, CREATE, INSERT, UPDATE, DELETE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES ON motion_diner_test.* TO 'motion_diner'@'localhost';
    FLUSH PRIVILEGES;
