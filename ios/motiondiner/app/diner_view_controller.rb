class DinerViewController < UIViewController

  def loadView
    self.view = UIView.alloc.init
    self.title = "Locator"
  end

  def viewDidLoad
    @mapView = MKMapView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @mapView.setShowsUserLocation("YES")
    view.addSubview @mapView

    @locationManager = CLLocationManager.alloc.init
    @locationManager.delegate = self
    @locationManager.startUpdatingLocation

    return true
  end

end
