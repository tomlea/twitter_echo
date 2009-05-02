# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_twitter_echo_session',
  :secret      => 'c87fdfbff4405a6ea1656b8b48fd6419f0a34b75c2cbbf09fd280d0305eed7a38ff42c6098eb3d0be397a96df6b823809b9dfe2e0a63472705c0d6fa33d0166c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
