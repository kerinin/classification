# Pest, a framework for Probability Estimation

Pest provides a unified framework for interacting with different probability
estimation models.  

* Pest tries to be agnostic about the underlying data data structures, 
so changing libraries (GSL -> Hadoop) is as simple as using a different data source.
* Pest is designed to create estimators using subsets of larger data sources, and
transparently constructs estimators to facilitate dynamic querying
* Implementing custom estimation models is easy, and Pest implements some models

Pest abstracts common statstical operations including:

* Marginal, Joint and Conditional point probability
* Interval and Cumulative probability
* Entropy, Cross Entropy, and Mutual Information
* Mean, Median, Mode, etc


## Ruby Install
    brew install gnuplot  # This may take awhile...
    cd /usr/local
    git checkout 83ed494 /usr/local/Library/Formula/gsl.rb
    brew install gsl      # Forcing gsl v1.4

    bundle install 


## API

``` ruby
# Creating Datasets
test = Pest::DataSet::Hash.new hash                   # Creates a Hash dataset of observations from a hash
test = Pest::DataSet::Hash.new file                   # Creates a Hash dataset of observations from an IO (Marshalled) 
train = Pest::DataSet::GSL.new file                   # Creates a GSL dataset from and IO instance

# DataSet Variables
test.variables                                        # hash of Variable instances detected in observation set
test.v                                                # alias of 'variables'
test.v[:foo]                                          # a specific variable
test.v[:foo] = another_variable                       # explicit declaration

# Creating Estimators
e = Pest::Estimator::Set::Multinomial.new(test)       # Creates a multinomial estimator for set o
e = Pest::Estimator::Discrete::Gaussian.new(file)     # Creating an estimator with the DataSet API

# Descriptive Statistical Properties
e.mode(:foo)                                          # Mode
e.mean(:foo)                                          # Mean (discrete & continuous only)
e.median(:foo)                                        # Median (discrete & continuous only)
# quantile?
# variance?
# deviation?

# Estimating Entropy (Set & Discrete only)
e.entropy(:foo)                                       # Entropy of 'foo'
e.h(:foo, :bar)                                       # Joint entropy of 'foo' AND 'bar'
e.h(:foo).given(:bar)                                 # Cross entropy of 'foo' : 'bar'
e.mutual_information(:foo, :bar)                      # Mutual information of 'foo' and 'bar'
e.i(:foo, :bar)                                       # Alias

# Estimating Point Probability (Set & Discrete only)
e.probability(o.variables[:foo])                      # (Set/Discrete only) Estimate the probability of all values of 'foo'
e.p(:foo)                                             # Same as above, tries to find a variable named 'foo'
e.p(:foo).in(test)                                    # Estimate the probability of values in dataset 'test'
e.p(:foo).given(:bar).in(test)                        # Estimate the conditional foo | bar for the values in 'test'
e.p(:foo, :bar).in(test)                              # Estimate the joint probablity foo AND bar
e.p(:foo, :bar).given(:baz, :qux).in(test)            # More complex joint & conditional probabilities
e.p(:foo => 4, :bar => 2).given(:baz => 0)            # Single prediction (implicitly creates dataset)

# Estimating Cumulative & Interval Probability (Discrete & Continuous only)
e.probability(:foo).greater_than(:bar).in(test)
e.p(:foo).greater_than(:bar).less_than(:baz).in(test)
e.p(:foo).gt(:bar).lt(:baz).given(:qux).in(test)
```

Do we want variable equality to be name-based?  It may make more sense to allow
variables named differently in different data sets to be equivalent. And how the
fuck do we handle variable type?  I'm almost thinking we don't, and let the actual
estimators take care of type casting

## Python Install

    brew install gfortran
    brew install libyaml
    brew install pkg-config

    sudo easy_install pip
    sudo pip install scikit-learn
    sudo pip install scipy
    sudo pip install pyyaml

    git clone git://github.com/matplotlib/matplotlib.git
    cd matplotlib
    python setup.py build
    sudo python setup.py install

## Next Steps

I need to find some way of selecting features which are both predictive
of classes and diverse.  Mutual information seems to be a good scoring
metric, but I need something more.

Idea: Do this iteratively, start with the feature with the highest mutual
information.  At each step, choose the remaining feature whose MI with
the classes minus its MI with the current classifier is highest.  This
has a number of problems; calculating the MI between a feature and a set
of featurs being the largest.  Also requres re-calculating the MI betwen 
the estimator and the classes at each step

Lets start by verifying my assumption that the MI (and my implementation)
is correlated with Loss.
