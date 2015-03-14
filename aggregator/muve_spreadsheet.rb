require 'google_drive'
require './extensions'

class MuveSpreadsheet
  CONFIG = 'config.yml'

  def initialize(config)
    @spreadsheet_key = config['spreadsheet_key']

    google_auth_token = nil
    google_client = OAuth2::Client.new(
      config['client_id'],
      config['client_secret'],
      { site: 'https://accounts.google.com', token_url: '/o/oauth2/token', authorize_url: '/o/oauth2/auth' }
    )

    if config['refresh_token'].blank?
      # if we are missing a refresh token then get one
      google_auth_url = google_client.auth_code.authorize_url({
        redirect_uri: "urn:ietf:wg:oauth:2.0:oob",
        scope:  "https://docs.google.com/feeds/ " +
                "https://docs.googleusercontent.com/ " +
                "https://spreadsheets.google.com/feeds/"
      })

      # redirect the user to auth_url and get authorization code from redirect URL
      print("1. Open this page:\n#{ google_auth_url }\n\n")
      print("2. Enter the authorization code shown in the page: ")
      google_authorization_code = $stdin.gets.chomp

      google_auth_token = google_client.auth_code.get_token(
        google_authorization_code, { redirect_uri: "urn:ietf:wg:oauth:2.0:oob" }
      )

      if google_auth_token.present? && google_auth_token.refresh_token.present?
        # save the refresh token to our config file for later
        data = YAML.load_file(CONFIG)
        data['google']['refresh_token'] = google_auth_token.refresh_token
        File.open(CONFIG, 'w') {|f| YAML.dump(data, f)}
      end
    else
      # we already have a refresh token so use it
      at = OAuth2::AccessToken::from_hash(google_client, { refresh_token: config['refresh_token'] })
      at = at.refresh!
      google_auth_token = at
    end

    @google_session = GoogleDrive.login_with_oauth(google_auth_token.token)
  end

  def add_new_row(row)
    @worksheet ||= @google_session.spreadsheet_by_key(@spreadsheet_key).worksheets[0]

    # don't insert a new row if the media_url is blank or it is a duplicate
    return if row[:media_url].blank? || is_duplicate?(row[:source], row[:id])

    # insert into the next row
    row_num = @worksheet.num_rows + 1
    @worksheet[row_num, 1] = row[:source]
    @worksheet[row_num, 2] = row[:id]
    @worksheet[row_num, 3] = row[:created]
    @worksheet[row_num, 4] = row[:hashtag]
    @worksheet[row_num, 5] = row[:url]
    @worksheet[row_num, 6] = row[:media_url]
    @worksheet[row_num, 7] = 'no'

    # save if we made changes
    @worksheet.save if @worksheet.dirty?
  end

  private
    def is_duplicate?(source, id)
      # check for duplicates by media_url
      (1..@worksheet.num_rows).detect {|i| (@worksheet[i, 1].to_s == source.to_s) && (@worksheet[i, 2].to_s == id.to_s)} != nil
    end
end
