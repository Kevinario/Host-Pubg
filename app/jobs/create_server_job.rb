class CreateServerJob < ActiveJob::Base
  queue_as :default

  def perform(host,user,password,server_name,min,max)
    #args[0] = host
    #args[1] = username
    #args[2] = password
    #args[3] = server name
    #args[4] = server location
    #args[5] = minimum RAM (MB)
    #args[6] = maximum RAM (MB)
    #args[7] = server port
    
    
    Net::SSH.start(host, user, :password => password) do |ssh|
      ssh.exec!("cd /opt/ && sudo mkdir #{server_name} && cd #{server_name} && sudo wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar && sudo java -jar BuildTools.jar --rev 1.12.2 && screen -dm -S #{server_name} sudo java -Xms#{min}M -Xmx#{max}M -jar /opt/#{server_name}/spigot-1.12.2.jar nogui && sudo cp /opt/library/eula.txt /opt/#{server_name}/eula.txt && screen -dm -S #{server_name} sudo java -Xms#{min}M -Xmx#{max}M -jar /opt/#{server_name}/spigot-1.12.2.jar nogui")
      StopServerJob.set(wait: 5.minute).perform_now(host,user,password,name)
    end
  end
end
