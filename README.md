
## Ruby Install
    brew install gnuplot  # This may take awhile...
    cd /usr/local
    git checkout 83ed494 /usr/local/Library/Formula/gsl.rb
    brew install gsl      # Forcing gsl v1.4

    bundle install 


## API

All data transfer is file-based.  Input files are assumed to contain sets
of observations, but no assumption is made as to file type. 

``` ruby
o = Distribution::DataSet.from_csv 'filename.csv'   # Creates a new set of observations
o.variables                                         # => array of Variable instances detected in observation set
o.v                                                 # alias of Observations#variables

Distribution::Discrete::Category                    # Taking values from an unordered set ('apple', 'pear', 'zebra')
Distribution::Discrete::Mass                        # Taking values in a finite, ordered, metric set (integers between 0 and 10)
Distribution::Continuous::Density                   # Taking values in an ordered, metric set (real numbers between 0 and 10)

pdf = Distribution::Discrete::Gaussian.new(o)       # Creates a Gaussian PDF estimator from observations
pdf.v                                               # inherited from observations
pdf.p(pdf.v.first == 1)                             # probability of the first variable taking a value 
pdf.p(pdf.v.first).given(pdf.v.last == 1)           # conditional probability
pdf.p(pdf.v.first == 1, pdf.v.last == 2)            # joint probability
pdf.p(pdf.v.first).given(pdf.v.last == 1)           # probability of all known values of variable

pdf.v.first.h                                       # Entropy of variable
pdf.v.first.h.given(pdf.v.last == 1)                # Entropy of conditional variable
pdf.v.first.h.given(pdf.v.last.h)                   # Conditional Entropy
pdf.v.first.cross_entropy(pdf.v.last)               # Cross entropy
pdf.v.first.mutual_information(pdf.v.last)          # Mutual Information

pdf.h                                               # Returns hash containing all variables' entropy
pdf.cross_entropy(pdf.v.first)                      # Returns hash of all variables cross vs variable (excluding that variable)
pdf.mutual_information(pdf.v.first)                 # Same as above
```

I think we want to define base classes for discrete and continuous distributions.
asking for the conditional probability without an argument makes sense for 
discrete distributions (return all the things!), but not for continuous. Some of the 
information metrics are also undefined for cts variables

I think this should all be lazily executed, but that's really an implementation
detail.

I'm wondering if the 'file-centric' bit should extend to conditional values, ie you
can't pass `pdf.v.last == 1`, you have to pass a set of observations that defines
that in a file.


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
