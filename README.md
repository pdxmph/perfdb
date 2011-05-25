# PerfDB

PerfDB is a basic Rails application for caching and analyzing Google Analytics data for a number of sites. 

PerfDB requires a working Google Analytics account with access to the necessary sites. Look for the file `config/qs-garb-setup.rb` and modify the user and password as appropriate.

To get a look at the active schema, either consult the `/models` directory, or consult `/perfdb\_schema.pdf` for a visual map of the relationships between tables.

Once data is migrated from the existing database to a new MySQL server, you'll need to modify `/config/database.yml` to access it from within the application.

The Web component of PerfDB is largely unfinished. Instead, it's currently best to maintain and operate the app using a collection of scripts in the `/script` directory. 

## Some key scripts for maintaining PerfDB:


### 1. Import Article Data

- import\_cdev\_dump.rb : This is the primary script for importing article data from CDEV-based sites. It's provided in a dump  on a monthly basis using a ^-delimited format. 

Note line 11, where the path of the import file is set:

import\_file = File.read("/Users/mike/Desktop/all\_articles\_feb11.txt")


- import\_content\_engine\_articles.rb :  This is the primary script for importing article data from Content Engine sites. A sample is located in the file import\_files/cms\_reports/ce\_february.xls

- import\_revenue\_by\_month.rb - Given a simple spreadsheet with monthly site revenue figures, this imports the data by site for use in RPV reporting. Check the script for a sample file.

### 2. Import Analytics Data

- gather\_monthly\_site\_stats.rb: Imports site pageview stats for use in other reporting.
- gather\_monthly\_social\_analytics.rb: Imports social networking analytics data
- pdb\_update.rb: Gathers the article pageview data: Run at least every two days or so to keep the query quota usage low.


### 3. Editor Reporting Scripts (use these to provide editors with reporting spreadsheets and import 

- generate\_monthly\_spreadsheets.rb : Produces the spreadsheets needed by editors to report on articles
- import\_edited\_sheets.rb: Imports finished spreadsheets. Check the script for where these spreadsheets should be placed for import.

### 4. General Reporting Scripts

Most of these scripts output to CSV for import to Excel

- author\_dump.rb : Reports on article performance by all authors.
- find\_incompletes\_by\_site.rb: Find articles missing effort, content type or content source
- export\_list\_of\_zero\_lifetime\_views.rb: Good for tracking down issues in Analytics importing
- generate\_cumulative\_report.rb: use to output a CSV file of all article data for import into Excel

### Misc Scripts

`/script/misc_scripts` contains a number of simple scripts for performing other actions. If they fail to run, make sure to check the include paths:

`require File.dirname(__FILE__) + '/../../config/environment'`

