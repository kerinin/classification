namespace :naive_bayes do
  namespace :performance do
    task :leave_one_out, [:path] => :environment do |t, args|
      # Sets default args, constructs @paths array
      include RakeHelpers::Performance::LeaveOneOut

      @paths.each do |path|
        data = Pest::DataSet::NArray.from_csv(path)
        performance = Classification::NaiveBayes.new(data).leave_one_out_performance
        puts performance
      end
    end

    task :k_fold, [:path, :k] => :environment do |t, args|
      # Sets default args, constructs @paths array
      include RakeHelpers::Performance::KFold

      @paths.each do |path|
        data = Pest::DataSet::NArray.from_csv(path)
        performance = Classification::NaiveBayes.new(data).k_fold_performance(args.k)
        puts performance
      end
    end
  end
end
