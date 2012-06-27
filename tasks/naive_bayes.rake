namespace :naive_bayes do
  namespace :performance do
    task :leave_one_out, [:variable, :path] => :environment do |t, args|
      @paths = RakeHelpers.parse_path(args.path)

      @paths.each do |path|
        data = Pest::DataSet::NArray.from_csv(path)
        performance = Classification::NaiveBayes.leave_one_out_performance(data, args.variable)
        puts performance
      end
    end

    task :k_fold, [:variable, :path, :k] => :environment do |t, args|
      @paths = RakeHelpers.parse_path(args.path)

      @paths.each do |path|
        data = Pest::DataSet::NArray.from_csv(path)
        performance = Classification::NaiveBayes.k_fold_performance(data, args.variable, args.k.to_i)
        puts performance
      end
    end
  end
end
