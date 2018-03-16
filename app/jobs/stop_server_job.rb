class StopServerJob < ActiveJob::Base
  queue_as :default

  def perform(host,user,password,name)
    #args[0] = host
    #args[1] = username
    #args[2] = password
    #args[3] = screen name
    
    
    Net::SSH.start(host, user, :password => password) do |ssh|
      ssh.exec!('screen -S ' + name +  ' -X stuff "`echo -ne \"stop\r\"`"')
    end
  end
end
