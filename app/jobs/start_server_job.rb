class StartServerJob < ActiveJob::Base
  queue_as :default
  def perform(host,user,password,name,min,max,folder,jar)
    #Migrate ssh info to environment variables
    #args[0] = host
    #args[1] = username
    #args[2] = password
    #args[3] = screen name
    #args[4] = minimum RAM (MB)
    #args[5] = maximum RAM (MB)
    #args[6] = Folder Location
    #args[7] = Jar File location

    
    

    Net::SSH.start(host, user, :password => password) do |ssh|
      result = ssh.exec!("cd #{folder} && screen -dm -S #{name} sudo java -Xms#{min}M -Xmx#{max}M -jar #{jar} nogui")
    end
    
  end
end
