class User < ActiveRecord::Base

  # Must include a Module which implements hexdigest(),
  # such as Digest::SHA1.hexdigest().

  extend SHA1Digester

  validates_presence_of   :name
  validates_uniqueness_of :name

  attr_accessor :password_confirmation
  validates_confirmation_of :password

  validate :password_non_blank

  def self.authenticated_user(username, password)
    user = User.find_by_name(username)
    return nil unless user
    encrypted_password = User.encrypted_password(password, user.salt)
    return encrypted_password == user.hashed_password ? user : nil
  end

  def writer?
    return is_writer
  end

  def admin?
    return is_admin
  end

  # 'password' is a virtual attribute
  def password
    return @password
  end

  def password=(value)
    @password = value
    return if value.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(password, salt)
  end

  private

    DELIMITER = 'wibble'

    def self.encrypted_password(password, salt)
      string_to_hash = password + DELIMITER + salt
      return hexdigest(string_to_hash)
    end

    def password_non_blank
      errors.add(:password, "Password missing") if hashed_password.blank?
    end

    def create_new_salt
      self.salt = self.object_id.to_s + rand.to_s
    end
end

