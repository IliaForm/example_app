# Be sure to restart your server when you modify this file.

SampleApp::Application.config.session_store :cookie_store, :key => '_sample_app_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# SampleApp::Application.config.session_store :active_record_store
#ActionController::Base.session = {
 # :key         => '_sample_app_session',
#  :secret      => '14f50711b8f0f49572rtgweuthwue4t5'
#}