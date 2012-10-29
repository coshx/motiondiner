class TruckViewController < UIViewController

  def loadView
    self.view = UIView.alloc.init
    self.title = "Run a Truck"
    # set background color to a nice steel blue
    self.view.backgroundColor = AppConstants.defaultBackgroundColor
    @truck = ErrorTruck.new
  end

  def viewDidLoad
    @truckIDLabel = makeTruckIDLabel
    self.view.addSubview(@truckIDLabel)

    @truckIDTextField = makeTruckIDTextField
    view.addSubview(@truckIDTextField)

    # @truckStatusLabel = makeTruckStatusLabel
    view.addSubview(@truckStatusLabel)

    @truckStatus = makeTruckStatus
    view.addSubview(@truckStatus)

    @truckNameLabel = makeTruckNameLabel
    view.addSubview(@truckNameLabel)

    @truckName = makeTruckName
    view.addSubview(@truckName)

    makeTruckOpenCloseButton
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

  # def makeTruckStatusLabel
  #   labelFrame = [[10,120], [120, 30]] # origin, size
  #   label = UILabel.alloc.initWithFrame(labelFrame)
  #   label.text = "Currently Open?"
  #   label.backgroundColor = UIColor.clearColor
  #   label.font = UIFont.boldSystemFontOfSize(16)
  #   label.textAlignment = UITextAlignmentLeft
  #   label
  # end

  def makeTruckStatus
    labelFrame = [[10,120], [200, 30]] # origin, size
    label = UILabel.alloc.initWithFrame(labelFrame)
    label.text = @truck.state
    label.backgroundColor = UIColor.clearColor
    label.font = UIFont.boldSystemFontOfSize(16)
    label.textAlignment = UITextAlignmentLeft
    label
  end

  def makeTruckNameLabel
    labelFrame = [[10,90], [120, 30]] # origin, size
    label = UILabel.alloc.initWithFrame(labelFrame)
    label.text = "Truck Name:"
    label.backgroundColor = UIColor.clearColor
    label.font = UIFont.boldSystemFontOfSize(16)
    label.textAlignment = UITextAlignmentLeft
    label
  end

  def makeTruckName
    labelFrame = [[130,90], [200, 30]] # origin, size
    label = UILabel.alloc.initWithFrame(labelFrame)
    label.text = @truck.state
    label.backgroundColor = UIColor.clearColor
    label.font = UIFont.boldSystemFontOfSize(16)
    label.textAlignment = UITextAlignmentLeft
    label
  end

  def truckOpenCloseButton
    @truckOpenCloseButton || makeTruckOpenCloseButton
  end

  def makeTruckOpenCloseButton
    @truckOpenCloseButton = UISwitch.alloc.initWithFrame([[200, 125], [0, 0]])
    @truckOpenCloseButton.addTarget(self,
                                    action:'truckOpenCloseButtonChanged',
                                    forControlEvents:UIControlEventValueChanged)
    view.addSubview(@truckOpenCloseButton)
    # setTruckOpenClosedButtonEnabledState
  end

  def truckOpenCloseButtonChanged
    if @truckOpenCloseButton.on?
      @truck.open! do
        updateTruckStatusText
        # setTruckOpenClosedButtonEnabledState
      end
    else
      @truck.close! do
        updateTruckStatusText
        # setTruckOpenClosedButtonEnabledState
      end
    end
  end

  def toggleButtonState
    if @truck.nil? || @truck.error?
      disableButton(truckOpenCloseButton)
    else
      enableButton(truckOpenCloseButton)
    end
  end

  # def setTruckOpenClosedButtonEnabledState
  #   if @truck && [:open, :close].include?(@truck.state)
  #     @truckOpenCloseButton.on(@truck.state == :open)
  #     # title = @truck.state == :open ? 'Close Truck' : 'Open Truck'
  #   end
  # end

  def updateTruckStatusText
    # setTruckOpenClosedButtonEnabledState
    return "Please enter ID" unless @truck
    p "truck: #{@truck}, state: #{@truck.state}"
    text = case @truck.state
      when :open
        "Currently Open!"
      when :close
        "Currently Closed."
      else
        @truck.state
    end

    @truckStatus.text = text

    @truckName.text = @truck.name
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
