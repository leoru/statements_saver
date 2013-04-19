# encoding: utf-8
require 'rubygems'
require 'google_drive'
require 'pony'

class StatementsSaver
  EMAIL_RECIEVER = "worktmn@gmail.com"

  AUTH_LOGIN = "uchet72@gmail.com"
  AUTH_PASSWORD = "account1234"
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

    send_mail(time,params)

  end

  def self.send_mail(time,params)
    text = time + "; " + params[:device_id] + "; " + params[:statements]
    Pony.mail :to => EMAIL_RECIEVER,
            :subject => 'Новые данные' ,
            :body => text ,
            :via => :smtp,
            :via_options => {
              :address              => 'smtp.gmail.com',
              :port                 => '587',
              :enable_starttls_auto => true,
              :user_name            => AUTH_LOGIN,
              :password             => AUTH_PASSWORD,
              :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
              :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
            }
  end




end