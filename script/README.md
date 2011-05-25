# Scripts for PerfDB - 5/18/2011

Some key scripts for maintaining PerfDB:


1. Import Article Data

- import_cdev_dump.rb : This is the primary script for importing article data from CDEV-based sites. It's provided in a dump from Heidi Crye on a monthly basis using a ^-delimited format. 

Note line 11, where the path of the import file is set:

import_file = File.read("/Users/mike/Desktop/all_articles_feb11.txt")


- import_content_engine_articles.rb :  This is the primary script for importing article data from Content Engine sites. Paxton Chow can provide this report. A sample is located in the file import_files/cms_reports/ce_february.xls

- import_revenue_by_month.rb - Given a simple spreadsheet with monthly site revenue figures, this imports the data by site for use in RPV reporting. Check the script for a sample file.

2. Import Analytics Data

- gather_monthly_site_stats.rb: Imports site pageview stats for use in other reporting.
- gather_monthly_social_analytics.rb: Imports social networking analytics data
- pdb_update.rb: Gathers the article pageview data: Run at least every two days or so to keep the query quota usage low.


3. Editor Reporting Scripts (use these to provide editors with reporting spreadsheets and import 

- generate_monthly_spreadsheets.rb : Produces the spreadsheets needed by editors to report on articles
- import_edited_sheets.rb: Imports finished spreadsheets. Check the script for where these spreadsheets should be placed for import.

4. General Reporting Scripts

Most of these scripts output to CSV for import to Excel

- author_dump.rb : Reports on article performance by all authors.
- find_incompletes_by_site.rb: Find articles missing effort, content type or content source
- export_list_of_zero_lifetime_views.rb: Good for tracking down issues in Analytics importing
- generate_cumulative_report.rb: use to output a CSV file of all article data for import into Excel
