namespace :scheduler do
  desc "This task is called once a day by the Heroku scheduler add-on"
  task :daily => :environment do
    DeleteOldDismissalsJob.perform_later
  end
end
