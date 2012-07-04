module Classification
  class NaiveBayes
    def self.leave_one_out_performance(data, variable)
      l = data.length
      correct = 0
      total = 0
      (0...l).to_a.each do |i|
        data_subset = data.except(i,i+1)

        classifier = Classification::NaiveBayes.new(data_subset, variable)

        predicted = classifier.classify(data[i])
        actual = data[i].pick(variable).to_hash[data.variables[variable]]
        puts [predicted,actual]

        (0...predicted.length).to_a.each do |i|
          if predicted[i] == actual[i]
            correct += 1
          end
          total += 1
        end
        print "."
        $stdout.flush
      end
      print "\n"
      $stdout.flush
      return correct / total.to_f
    end

    def self.k_fold_performance(data, variable, k=2)
      l = data.length
      correct = 0
      total = 0
      (0...k).to_a.each do |i|
        this_correct = 0
        this_total = 0
        left = i * l / k
        right = (i+1) * l / k
        train_subset = data.except(left, right)
        test_subset = data[left...right]

        classifier = Classification::NaiveBayes.new(train_subset, variable)

        predicted = classifier.classify(test_subset)
        actual = test_subset.pick(variable).to_hash[test_subset.variables[variable]]
        print "\n"
        print predicted
        print "\n"
        print actual
        print "\n"

        (0...predicted.length).to_a.each do |i|
          if predicted[i] == actual[i]
            this_correct += 1
          end
          this_total += 1
        end
        correct += this_correct
        total += this_total
        print "%2.1f%%: %s/%s" % [100 * this_correct / this_total.to_f, this_correct, this_total]
      end
      print "\n"
      puts "-----"
      $stdout.flush
      return correct / total.to_f
    end

    attr_reader :data, :estimator, :class_var, :feature_vars

    def initialize(data, class_var, feature_vars=nil)
      @data = data
      @estimator = Pest::Estimator::Frequency.new(data)
      @class_var = estimator.to_variable(class_var)
      if feature_vars
        @feature_vars = Array(feature_vars).map{|v| estimator.to_variable(v)}
      else
        @feature_vars = data.variables.reject{|k,v| k.to_s == class_var.to_s}.values
      end
    end

    def classify(test_data)
      # Find unique values of class var
      unique_values = data.pick(class_var).to_a.flatten.uniq

      # Deternmine conditional probability of the class var given each
      # of the feature vars
      # [n_features][n_classes, n_data]
      #
      conditional_prs = feature_vars.map do |feature_var|
        NArray[ unique_values.map do |class_value|
          hypothesis = hypothesize(test_data, class_var => class_value)
          conditional_probability(:given => feature_var, :in => hypothesis)
        end ].reshape!(unique_values.length, test_data.length)
      end

      # Determine the marginal probability of each value of class var
      # [n_classes]
      #
      class_probabilities = NArray[ unique_values.map {|v| estimator.p(class_var => v).evaluate } ]

      # For each unique value, calculate the product of the marginal probability
      # and the conditional probabilities given each feature var
      # [n_classes, n_data]
      #
      class_scores = conditional_prs.inject(class_probabilities) do |memo, obj|
        # Normalize so we don't diverge to 0/infty
        raw = obj * memo
        raw / raw.sum(1)
      end

      # For each vector in test_data, return the class with the 
      # highest score
      # [n_data]
      #
      class_scores.to_a.map do |scores| 
        scores.each_with_index.max[1]
      end.map do |index|
        unique_values[index]
      end
    end

    def hypothesize(data_set, givens)
      given_data = {}
      givens.each_pair do |k,v|
        given_data[k] = Array(v) * data_set.length
      end

      data_set.merge Pest::DataSet::Hash.from_hash(given_data)
    end

    def conditional_probability(args)
      NArray[ estimator.batch_p(class_var).given(args[:given]).in(args[:in]).evaluate ]
    end
  end
end
