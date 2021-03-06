require "rubygems"
require "garb"
require "garb/reports"

google_user = ""
google_password = ""

tries = 0

begin
  Garb::Session.login(google_user, google_password)
rescue => ex
  puts "\t\t\t*** Error starting session, retrying ..."
  if (tries < 10)
    sleep(1**tries)
    tries +=1
    retry
  end
end

@profiles = Garb::Management::Profile.all
