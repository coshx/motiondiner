class TruckViewController < UIViewController

  def loadView
    self.view = UIView.alloc.init
    self.title = "Run a Truck"
    # set background color to a nice steel blue
    self.view.backgroundColor = AppConstants.defaultBackgroundColor
    @truck = nil # no truck until an ID is entered
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

    # now that we have the buttons, set their initial state to disabled (calling check will disable them since we don't have a truck yet)
    toggleButtonState
  end

  # need to tie in to touch callbacks to hide keyboard when user taps away
  # adapted from http://stackoverflow.com/questions/1456120/hiding-the-keyboard-when-losing-focus-on-a-uitextview
  def touchesBegan(touches, withEvent:event)
    touch = event.allTouches.anyObject
    if @truckIDTextField.isFirstResponder && touch.view != @truckIDTextField      
      @truckIDTextField.resignFirstResponder
      self.truckIDEntered
    end

    super # call super here or else the touch event get swallowed up
  end

  def truckIDEntered
    truckID = @truckIDTextField.text
    Truck.findTruck(truckID) do |truck|
      @truck = truck
      updateTruckStatusText
      toggleButtonState
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
      if @truck
        @truck.open! do
          updateTruckStatusText
        end
      end
    end
  end

  def makeTruckCloseButton
    button = UIButton.buttonWithType UIButtonTypeRoundedRect
    button.frame = [[10, 210], [300, 30]]
    button.setTitle("Close Truck", forState:UIControlStateNormal)
    button.when(UIControlEventTouchUpInside) do
      if @truck
        @truck.close! do
          updateTruckStatusText
        end
      end
    end
  end

  def toggleButtonState
    buttons = [@truckOpenButton, @truckCloseButton]

    if @truck.nil? || @truck.error?
      buttons.each { |button| disableButton(button) }
    else
      buttons.each { |button| enableButton(button) }
    end
  end

  def updateTruckStatusText
    return "Please input ID" unless @truck
    p "truck: #{@truck}, state: #{@truck.state}"
    text = case @truck.state
      when :open
        "Open!"
      when :close
        "Closed."
      else
        "Error"
    end

    @truckStatus.text = text
  end

  def disableButton(button)
    button.alpha = 0.6 # makes it look 'grayed out' and inactive
    button.enabled = false
  end

  def enableButton(button)
    button.alpha = 1.0 # restore to looking active and pushable
    button.enabled = true
  end

end
