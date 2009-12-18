# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_fifa10_session',
  :secret      => '49dc240c05765cae4b5d1da9359eb73d3607822e32be5bb2129079713f61c4a613e4db1a592cec0c3b25b00fcc79096daa9ac1647d18c5a3f0d11ea6fb7fc0c1'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
