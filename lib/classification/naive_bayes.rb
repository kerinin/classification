module Classification
  class NaiveBayes
    def self.leave_one_out_performance(data, variable)
      l = data.length
      correct = 0
      total = 0
      (0..l-1).to_a.each do |i|
        classifier = Classification::NaiveBayes.new(data[0..i] + data[i+1..l-1], variable)
        if classifier.classify(data[i]) == data[i].to_hash[variable]
          correct += 1
        end
        total += 1
      end
      return correct / total.to_f
    end

    def self.k_fold_performance(data, variable, k=2)
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
      unique_values = data.data_vectors(class_var).to_a.first.uniq

      # Determine the probability of each class
      # Returns [n_classes][n_data]
      class_probabilities = unique_values.map do |class_value|
        data_with_class_value = test_data + 
          Pest::DataSet::Hash.new({
            class_var => Array(class_value) * test_data.length
          })

        # Determine Pr(class_var) * Product(Pr(class_var, feature_vars))
        # Returns [n_features][n_data]
        feature_vars.each do |feature_var|
          # Calculate the Pr(class_var | feature_var)
          # Returns [n_data]
          estimator.p(class_var => class_value).given(feature_var).in(data)

        end.inject(estimator.p(class_var)) do |joint, marginal|
          # calculate the product of the Pr(class_var) and all Pr(class_var | feature_var)'s
          # Returns [n_data]
          joint * marginal
        end
      end

      # Determine the class labels with the highest probability
      # Returns [n_data]
      # RM NOTE: Ugly, but I'm trying to avoid assuming the data set defines #transpose
      (0..test_data.length-1).to_a.map do |i|
        class_probabilities.map do |class_probability_array|
          class_probability_array[i]
        end.each_with_index.max[1]
      end
    end
  end
end
