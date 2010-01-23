class Array

  # Returns a hash whose keys correspond to the unique return values from evaluating the condition symbol
  # and whose values are arrays containing the elements that match the keys. If the condition results in a
  # nil value, the element is ignored
  #
  # This is commonly needed when an array of models need to be grouped by a user, status, or some other
  # property and treated as a "hashed-array"
  #
  # Examples:
  #
  #   Using a Symbol:
  #
  #   >> a = ["1","2","3","1"] # Hashcodes are 50,51,52,50 respectively
  #   >> a.hashed_by :hash
  #   => {50=>["1", "1"], 51=>["2"], 52=>["3"]}
  #
  #   Using a Block:
  #
  #   >> a = ["1","2","3","1"]
  #   >> a.hashed_by { |element| element.to_s }
  #   => {"1"=>["1", "1"], "2"=>["2"], "3"=>["3"]}
  #
  def hash_by(condition=nil)
    hash = Hash.new

    self.each do |element|
      # TODO: Add support for strings
      key = nil
      case condition
        when Symbol: key = element.send(condition)
        when nil: key = yield element if block_given?
      end

      if key
        if !hash[key]
          hash[key] = Array.new
        end
        hash[key] << element
      end
    end

    return hash
  end
end
