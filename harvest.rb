require 'rubygems'
require 'bundler/setup'
require 'flickraw'
require 'google_drive'
require './twitter_harvest'
require 'yaml'

# load the config file - this should have all the access
# keys for twitter, facebook, instagram and flickr
config = YAML.load_file('config.yml')

twitter = TwitterHarvest.new(
  config['twitter']['consumer_key'],
  config['twitter']['consumer_secret'],
  config['twitter']['access_token'],
  config['twitter']['access_token_secret']
)

twitter_data = twitter.search('#vkpn1')



# do we already have a refresh token?
google_auth_token = nil
google_client = OAuth2::Client.new(
  config['google']['client_id'],
  config['google']['client_secret'],
  { site: 'https://accounts.google.com', token_url: '/o/oauth2/token', authorize_url: '/o/oauth2/auth' }
)

if (config['google']['refresh_token'] || '') == ''
  google_auth_url = google_client.auth_code.authorize_url({
    redirect_uri: "urn:ietf:wg:oauth:2.0:oob",
    scope:  "https://docs.google.com/feeds/ " +
            "https://docs.googleusercontent.com/ " +
            "https://spreadsheets.google.com/feeds/"
  })

  # Redirect the user to auth_url and get authorization code from redirect URL.
  print("1. Open this page:\n#{ google_auth_url.authorization_uri }\n\n")
  print("2. Enter the authorization code shown in the page: ")
  google_authorization_code = $stdin.gets.chomp

  google_auth_token = google_client.auth_code.get_token(
    google_authorization_code, { redirect_uri: "urn:ietf:wg:oauth:2.0:oob" }
  )
else
  at = OAuth2::AccessToken::from_hash(google_client, { refresh_token: config['google']['refresh_token'] })
  at = at.refresh!
  google_auth_token = at
end

google_session = GoogleDrive.login_with_oauth(google_auth_token.token)

ws = google_session.spreadsheet_by_key( config['google']['spreadsheet_key'] ).worksheets[0]
twitter_data.each do |row|
  row_num = ws.num_rows + 1
  ws[row_num, 1] = row[:source]
  ws[row_num, 2] = row[:id]
  ws[row_num, 3] = row[:created]
  ws[row_num, 4] = row[:hashtag]
  ws[row_num, 5] = row[:url]
  ws[row_num, 6] = row[:media_url]
  ws[row_num, 7] = ''
  ws[row_num, 8] = 'no'
end

ws.save if ws.dirty?

