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

        (0...l).to_a.each do |i|
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
        left = i * l / k
        right = (i+1) * l / k
        train_subset = data.except(left, right)
        test_subset = data[left...right]

        classifier = Classification::NaiveBayes.new(train_subset, variable)

        predicted = classifier.classify(test_subset)
        actual = test_subset.pick(variable).to_hash[test_subset.variables[variable]]

        (0...l).to_a.each do |i|
          if predicted[i] == actual[i]
            correct += 1
          end
          total += 1
        end
        print "."
      end
      print "\n"
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
      unique_values = data.pick(class_var).to_a.flatten.uniq

      # Determine the probability of each class
      # Returns [n_classes][n_data]
      class_probabilities = unique_values.map do |class_value|
        data_with_class_value = test_data.merge Pest::DataSet::Hash.from_hash({
            class_var => Array(class_value) * test_data.length
          })

        # Determine Pr(class_var) * Product(Pr(class_var, feature_vars))
        # Returns [n_features][n_data]
        feature_vars[0..0].map do |feature_var|
          # Calculate the Pr(class_var | feature_var)
          # Returns [n_data]
          NVector[ estimator.batch_p(class_var).given(feature_var).in(data_with_class_value).evaluate ]

        end.inject(estimator.p(class_var => class_value).evaluate) do |joint, marginal|
          # calculate the product of the Pr(class_var) and all Pr(class_var | feature_var)'s
          # Returns [n_data]
          joint * marginal
        end
      end

      # Determine the class labels with the highest probability
      # Returns [n_data]
      # RM NOTE: Ugly, but I'm trying to avoid assuming the data set defines #transpose
      (0...test_data.length).to_a.map do |i|
        class_probabilities.map do |class_probability_array|
          class_probability_array.to_a[i]
        end.each_with_index.max[1]
      end
    end
  end
end
