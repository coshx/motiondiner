class Array
  def distribution_hash
    b = Hash.new(0)
    self.each do |v|
      b[v] += 1
    end
    b
  end
end