require 'rubygems'
require 'google_drive'

class StatementsSaver

  AUTH_LOGIN = "kirillkunst@gmail.com"
  AUTH_PASSWORD = "anna1989"
  FILE_PREFIX = "data_"

  def self.save(params)
    time = Time.new
    time_string = time.strftime("%d-%m-%y")
    ws_time_string = time.strftime("%d-%m-%y %H:%M")
    filename = FILE_PREFIX + time_string
    session = GoogleDrive.login(AUTH_LOGIN, AUTH_PASSWORD)

    ws_file = session.spreadsheet_by_title(filename)
    if (ws_file.nil?)
      ws_file = session.create_spreadsheet(filename)
    end
    ws = ws_file.worksheets[0]

    row = ws.num_rows+1
    ws[row,1] = ws_time_string
    ws[row,2] = params[:device_id]
    ws[row,3] = params[:statements]

    ws.synchronize()

  end




end