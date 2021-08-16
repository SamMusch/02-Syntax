import warnings
warnings.filterwarnings("ignore", category=FutureWarning)
warnings.filterwarnings("ignore", category=DeprecationWarning)
pd.set_option('display.max_columns', 60) 
np.set_printoptions(precision=2)
import pandas as pd
import numpy as np
from pandas.plotting import scatter_matrix

import seaborn as sns
sns.set_theme(style="whitegrid")
%matplotlib inline
import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('axes', labelsize=14)
mpl.rc('xtick', labelsize=12)
mpl.rc('ytick', labelsize=12)


# Stats
from scipy import stats
import statsmodels.api as sm


# Data
import pandas_datareader
from pandas_datareader import data, wb
import quandl
import json
import requests
from bs4 import BeautifulSoup
import urllib


# Dates
from datetime import datetime, time, tzinfo, timedelta
import dateutil.parser as parser
from dateutil.parser import parse
from pandas.tseries.offsets import Day, MonthEnd


# Preprocess
from sklearn.base import BaseEstimator, TransformerMixin
from sklearn.pipeline import *
from sklearn.preprocessing import *
from sklearn import model_selection
from sklearn.model_selection import *
from sklearn.impute import SimpleImputer


# For classification
from matplotlib.colors import ListedColormap
from sklearn import neighbors, linear_model, LogisticRegression, tree
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import confusion_matrix, precision_recall_curve, average_precision_score, roc_curve, auc,classification_report, accuracy_score, plot_precision_recall_curve

# svm
from sklearn import svm
from sklearn.svm import *

# Ensemble
from sklearn.ensemble import RandomForestClassifier,RandomForestRegressor,ExtraTreesClassifier,VotingClassifier,BaggingClassifier,AdaBoostClassifier,GradientBoostingRegressor





