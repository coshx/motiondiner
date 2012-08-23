class TruckViewController < UIViewController

  def loadView
    self.view = UIView.alloc.init
    self.title = "Run a Truck"
    # set background color to a nice steel blue
    self.view.backgroundColor = AppConstants.defaultBackgroundColor
  end

  def viewDidLoad
    @truckIDLabel = makeTruckIDLabel
    self.view.addSubview(@truckIDLabel)

    @truckIDTextField = makeTruckIDTextField
    #@truckIDTextField.addTarget(self, action:"truckIDEntered", forControlEvents:UIControlEventEditingDidEndOnExit)
    view.addSubview(@truckIDTextField)

    @truckStatusLabel = makeTruckStatusLabel
    view.addSubview(@truckStatusLabel)

    @truckStatus = makeTruckStatus
    view.addSubview(@truckStatus)

    # @truckOpenButton = makeTruckOpenButton
    # view.addSubview(@truckOpenButton)

    # @truckCloseButton = makeTruckCloseButton
    # view.addSubview(@truckCloseButton)
  end

  # need to tie in to touch callbacks to hide keyboard when user taps away
  # adapted from http://stackoverflow.com/questions/1456120/hiding-the-keyboard-when-losing-focus-on-a-uitextview
  def touchesBegan(touches, withEvent:event)
    touch = event.allTouches.anyObject
    if @truckIDTextField.isFirstResponder && touch.view != @truckIDTextField      
      @truckIDTextField.resignFirstResponder
      self.truckIDEntered
    end

    super
  end

  def truckIDEntered    
    truckID = @truckIDTextField.text
    url = AppConstants.url + "/truck/#{truckID}"    
    BubbleWrap::HTTP.get(url) do |response|      
      #p response.body.to_str
      if response.ok?
        json = BubbleWrap::JSON.parse(response.body.to_str)
        open = json["open"]
        if open
          @truckStatus.text = "Open!"
        else
          @truckStatus.text = "Closed."
        end
      elsif response.status_code.to_s =~ /4\d\d/
        @truckStatus.text = "Error!"
        p response.error_message
      else
        @truckStatus.text = response.error_message
      end
    end
  end

  def makeTruckIDLabel
    labelFrame = [[10,40], [120, 30]] # origin, size
    label = UILabel.alloc.initWithFrame(labelFrame)
    label.text = "Truck ID:"
    label.backgroundColor = UIColor.clearColor
    label.font = UIFont.boldSystemFontOfSize(16)
    label.textAlignment = UITextAlignmentLeft    
    label
  end

  def makeTruckIDTextField
    textField = UITextField.alloc.init
    textField.frame = [[190,40], [120,30]]
    textField.borderStyle = UITextBorderStyleRoundedRect
    textField.placeholder = "Your ID #"
    textField.keyboardType = UIKeyboardTypeNumberPad
    textField.textAlignment = UITextAlignmentCenter    

    textField
  end

  def makeTruckStatusLabel
    labelFrame = [[10,90], [120, 30]] # origin, size
    label = UILabel.alloc.initWithFrame(labelFrame)
    label.text = "Your Status:"
    label.backgroundColor = UIColor.clearColor
    label.font = UIFont.boldSystemFontOfSize(16)
    label.textAlignment = UITextAlignmentLeft
    label
  end

  def makeTruckStatus
    labelFrame = [[130,90], [120, 30]] # origin, size
    label = UILabel.alloc.initWithFrame(labelFrame)
    label.text = "Please input ID"
    label.backgroundColor = UIColor.clearColor
    label.font = UIFont.boldSystemFontOfSize(16)
    label.textAlignment = UITextAlignmentCenter    
    label
  end

  def makeTruckOpenButton
    UIView.new
  end

  def makeTruckCloseButton
    UIView.new
  end

end