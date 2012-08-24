class Truck
  attr_accessor :id, :state
  
  def initialize(id, state)
    @id = id.to_i
    # state comes in as true for open, false for closed - although sometimes we get nil for 'not set', which we're treating as closed
    state = false if state.nil?
    @state = state ? :open : :close # don't treat nil as an error, treat it as closed
  end

  def open?
    @state == :open
  end

  def error?
    false
  end

  def self.findTruck(id, &block)
    url = getUrl(id)
    BubbleWrap::HTTP.get(url) do |response|
      if response.ok?
        json = BubbleWrap::JSON.parse(response.body.to_str)
        block.call( Truck.new(json["id"], json["open"]) )
      elsif response.status_code.to_s =~ /4\d\d/
        p "Error getting truck with id #{id}, HTTP response 4xx: #{response.status_code}"
        block.call( ErrorTruck.new(id, :error) )
      else
        p "Error getting truck with id #{id}, HTTP response: #{response.status_code}, error message: #{response.error_message}"
        block.call( ErrorTruck.new(id, :error) )
      end
    end
  end

  def open!(&block)
    updateRemoteStatus(:open, &block)
  end

  def close!(&block)
    updateRemoteStatus(:close, &block)
  end

protected

  def getUrl
    AppConstants.url + "/truck/{@id}"
  end

  def self.getUrl(id)
    AppConstants.url + "/truck/#{id}"
  end

  def updateUrl
    AppConstants.url + "/truck/#{@id}"
  end

  def openUrl
    updateUrl + "/open"
  end

  def closeUrl
    updateUrl + "/close"
  end

  def updateRemoteStatus(newStatus, &block)
    url = newStatus == :open ? openUrl : closeUrl
    p "update url: #{url}"
    BubbleWrap::HTTP.put(url) do |response|
      p "update response: #{response}"
      if response.ok?
        @state = newStatus
        block.call( @state )
      elsif response.status_code.to_s =~ /4\d\d/
        p "Updating got a 4xx response: #{response}"
        block.call( false )
      else        
        p "Updating got a non-4xx error: #{response}, error message: #{response.error_message}"
        block.call( false )
      end
    end
  end

end

# for when there is an error in fetching the truck at all, use this class
class ErrorTruck < Truck
  def initialize(id, state)
    super
  end

  def state
    "Error"
  end

  def error?
    true
  end

  def open!
    false
  end

  def close!
    false
  end
end
