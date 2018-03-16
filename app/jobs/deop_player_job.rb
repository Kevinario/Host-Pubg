class OpPlayerJob < ActiveJob::Base
  queue_as :default

  def perform(host,user,password,name,playerName)
    #args[0] = host
    #args[1] = username
    #args[2] = password
    #args[3] = screen name
    #args[4] = name of player to be deop'd
    
    Net::SSH.start(host,user,:password => password) do |ssh|
      ssh.exec!('screen -S ' + name + ' -X stuff "`echo -ne \"deop ' + playerName + '\r\"`"')
    end
  end
end
