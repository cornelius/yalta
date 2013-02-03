class Utils

  @@logger = nil

  def self.logger
    if !@@logger        
      if defined? RAILS_DEFAULT_LOGGER
        @@logger = RAILS_DEFAULT_LOGGER
      else
        @@logger = Logger.new STDERR
      end
    end
    @@logger
  end

  def self.make_random_string length = 8
    chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ0123456789'
    random_string = ''
    length.downto(1) { random_string << chars[rand(chars.length - 1)] }
    random_string
  end

end
