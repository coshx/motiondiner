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
    view.addSubview(@truckIDTextField)

    @truckStatusLabel = makeTruckStatusLabel
    view.addSubview(@truckStatusLabel)

    @truckStatus = makeTruckStatus
    view.addSubview(@truckStatus)

    @truckOpenButton = makeTruckOpenButton
    view.addSubview(@truckOpenButton)

    @truckCloseButton = makeTruckCloseButton
    view.addSubview(@truckCloseButton)
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
        updateTruckStatusText(json)
      elsif response.status_code.to_s =~ /4\d\d/
        @truckStatus.text = "Error!"        
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
    button = UIButton.buttonWithType UIButtonTypeRoundedRect
    button.frame = [[10, 150], [300, 30]]
    button.setTitle("Open Truck", forState:UIControlStateNormal)
    button.when(UIControlEventTouchUpInside) do
      updateRemoteTruckStatus(:open)      
    end
  end

  def makeTruckCloseButton
    button = UIButton.buttonWithType UIButtonTypeRoundedRect
    button.frame = [[10, 210], [300, 30]]
    button.setTitle("Close Truck", forState:UIControlStateNormal)
    button.when(UIControlEventTouchUpInside) do
      updateRemoteTruckStatus(:close)      
    end
  end

  def updateRemoteTruckStatus(state)    
    truckID = @truckIDTextField.text
    return unless truckID    
    url = AppConstants.url + "/truck/#{truckID}/#{state.to_s}"
    BubbleWrap::HTTP.put(url) do |response|      
      if response.ok?
        open = state == :open ? true : false
        updateTruckStatusText({"open" => open})
      elsif response.status_code.to_s =~ /4\d\d/
        @truckStatus.text = "Error!"
        p "Updating got a 4xx response: #{response}"
      else
        @truckStatus.text = response.error_message
        p "Updating got a non-4xx error: #{response}"
      end
    end
  end

  def updateTruckStatusText(json)    
    open = json["open"]
    if open
      @truckStatus.text = "Open!"
    else
      @truckStatus.text = "Closed."
    end 
  end

end