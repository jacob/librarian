# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_librarian_session',
  :secret      => '7df889abf00c6df835ff9a6cd270ecc4b224cdde24dac7289da1d79366406ca6416c98d0ed7feea350022667bc6b05a3225f25528aa81609a4ff80b91e87ccf9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
