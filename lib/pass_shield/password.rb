module PassShield
  module Password
    # Generate a random password of specified length
    # @param length [Integer] the length of the generated password (default is 12)
    # @return [String] a randomly generated password containing letters, digits, and symbols
    def self.generate(length = 12)
      chars = [*'a'..'z', *'A'..'Z', *'0'..'9', '!@#$%^&*()']
      chars.sample(length).join
    end
  end
end
