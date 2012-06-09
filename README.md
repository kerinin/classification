
## Ruby Install
    brew install gnuplot  # This may take awhile...
    cd /usr/local
    git checkout 83ed494 /usr/local/Library/Formula/gsl.rb
    brew install gsl      # Forcing gsl v1.4

    bundle install 


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
