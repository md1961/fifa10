require 'digest/sha1'


# Moduel to implement hexdigest(String) for class User.
module SHA1Digester

  def hexdigest(str)
    return Digest::SHA1.hexdigest(str)
  end
end

