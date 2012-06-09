namespace :data do
  desc "download data from rm.otherinbox.com to data"
  task :download do
    `rsync -av rm:/home/ubuntu/oib/current/classifier_training ./data/`
  end

  desc "remove data"
  task :reset do
    `rm -rf ./data/*`
  end
end
