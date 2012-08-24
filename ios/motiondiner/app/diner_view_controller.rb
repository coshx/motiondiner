class DinerViewController < UIViewController

  def loadView
    self.view = UIView.alloc.init
    self.title = "Locator"
  end

  def viewDidLoad
    @mapView = MKMapView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @mapView.setShowsUserLocation("YES")
    view.addSubview @mapView

    @searchBox = makeSearchBox
    view.addSubview @searchBox

    @locationManager = setupLocationManager

    return true
  end

  def makeSearchBox
    searchBox = UITextField.alloc.initWithFrame([[10,20], [300, 30]])
    searchBox.clearsOnBeginEditing = true
    searchBox.textColor = UIColor.whiteColor
    searchBox.borderStyle = UITextBorderStyleRoundedRect
    searchBox.delegate = self
    searchBox.text = "search"
    searchBox.opaque = "NO"
    searchBox.backgroundColor = UIColor.darkGrayColor.colorWithAlphaComponent(0.5)

    return searchBox
  end

  def setupLocationManager
    locationManager = CLLocationManager.alloc.init
    locationManager.delegate = self
    locationManager.startUpdatingLocation

    return locationManager
  end

  def locationManager(manager, didUpdateToLocation: newLocation, fromLocation: oldLocation)
    eventDate = newLocation.timestamp
    howRecent = eventDate.timeIntervalSinceNow

    coord = newLocation.coordinate
    setRegion(coord)
  end

  def setRegion(coord)
    @span = MKCoordinateSpan.new(0.02, 0.02)
    @region = MKCoordinateRegion.new(coord, @span)
    @mapView.setRegion(@region, animated: "YES")
  end

  def textFieldDidEndEditing(textField)
    puts 'left search box' if textField == @searchBox
  end

end
