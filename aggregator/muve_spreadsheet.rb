require 'google_drive'
require './extensions'

class MuveSpreadsheet
  def initialize(config)
    @spreadsheet_key = config['spreadsheet_key']

    # do we already have a refresh token?
    google_auth_token = nil
    google_client = OAuth2::Client.new(
      config['client_id'],
      config['client_secret'],
      { site: 'https://accounts.google.com', token_url: '/o/oauth2/token', authorize_url: '/o/oauth2/auth' }
    )

    if config['refresh_token'].blank?
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
      at = OAuth2::AccessToken::from_hash(google_client, { refresh_token: config['refresh_token'] })
      at = at.refresh!
      google_auth_token = at
    end

    @google_session = GoogleDrive.login_with_oauth(google_auth_token.token)
  end

  def add_new_row(row)
    @worksheet ||= @google_session.spreadsheet_by_key( @spreadsheet_key ).worksheets[0]

    return if row[:media_url].blank? || is_duplicate?(row[:media_url])

    row_num = @worksheet.num_rows + 1
    @worksheet[row_num, 1] = row[:source]
    @worksheet[row_num, 2] = row[:id]
    @worksheet[row_num, 3] = row[:created]
    @worksheet[row_num, 4] = row[:hashtag]
    @worksheet[row_num, 5] = row[:url]
    @worksheet[row_num, 6] = row[:media_url]
    @worksheet[row_num, 7] = 'no'

    @worksheet.save if @worksheet.dirty?
  end

  private
    def is_duplicate?(url)
      (1..@worksheet.num_rows).detect {|i| @worksheet[i, 6] == url} != nil
    end
end
