require 'net/ftp'
require 'zip'
require 'csv'
class FTP
  def download(server, username, password, file_dowload, destination_path)
    ftp = Net::FTP.new
    ftp.connect(server)
    ftp.login(username, password)
    ftp.getbinaryfile(file_dowload, destination_path)
    ftp.close
  end
end
