namespace :naive_bayes do
  namespace :performance do
    desc "Leave one out performance"
    task :leave_one_out, [:variable, :path] => :environment do |t, args|
      @paths = RakeHelpers.parse_path(args.path)
      puts "Starting..."

      @paths.each do |path|
        puts "Processing #{path}"
        data = Pest::DataSet::NArray.from_csv(path, :converters => [])
        puts "Data set loaded"
        performance = Classification::NaiveBayes.leave_one_out_performance(data, args.variable)
        puts "%2.1f%% accuracy" % [100 * performance]
      end
    end

    task :k_fold, [:variable, :path, :k] => :environment do |t, args|
      args.with_defaults :k => 2
      @paths = RakeHelpers.parse_path(args.path)

      require 'ruby-prof'
      result = RubyProf.profile do
        @paths.each do |path|
          data = Pest::DataSet::NArray.from_csv(path)
          performance = Classification::NaiveBayes.k_fold_performance(data, args.variable, args.k.to_i)
          puts "%2.1f%% accuracy" % [100 * performance]
        end
      end

      RubyProf::GraphHtmlPrinter.new(result).print(File.open('graph_html_profile.html', 'w'), :sort_method => :self_time)
      RubyProf::FlatPrinter.new(result).print(STDOUT, :min_percent => 0.1, :sort_method => :self_time)
    end
  end
end
