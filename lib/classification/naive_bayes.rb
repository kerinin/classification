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
      probabilities = conditional_probabilities(test_data)

      # .02
      scores = score_classes(probabilities)

      # .06
      class_from_score(scores)
    end


    # Private Methods

    # Deternmine conditional probability of the class var given each
    # of the feature vars
    # [n_features][n_classes, n_data]
    #
    def conditional_probabilities(test_data)
      hypotheses = hypotheses_for(test_data)

      feature_vars.map do |feature_var|
        NArray[ unique_values.map do |class_value|
          conditional_probability(:given => feature_var, :in => hypotheses[class_value])
        end ].reshape!(unique_values.length, test_data.length)
      end
    end

    def hypotheses_for(test_data)
      return_hash = {}
      unique_values.each {|v| return_hash[v] = hypothesize(test_data, class_var => v)}
      return_hash
    end

    def unique_values
      @unique_values ||= data.pick(class_var).to_a.flatten.uniq
    end

    def class_probabilities
      # Determine the marginal probability of each value of class var
      # [n_classes]
      #
      @class_probabilities ||= NArray[ unique_values.map {|v| estimator.p(class_var => v).evaluate } ]
    end

    # For each unique value, calculate the product of the marginal probability
    # and the conditional probabilities given each feature var
    # [n_classes, n_data]
    #
    def score_classes(conditional_probabilities) 
      conditional_probabilities.inject(class_probabilities) do |memo, obj|
        # Normalize so we don't diverge to 0/infty
        raw = obj * memo
        raw / raw.sum(1)
      end
    end


    # For each vector in class_scores, return the class with the 
    # highest score
    # [n_data]
    #
    def class_from_score(class_scores)
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
