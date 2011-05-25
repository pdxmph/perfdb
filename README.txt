# PerfDB Database Structure

This is a quick overview. See perfdb_schema.pdf for a complete list of the columns in each table. 

Article:
--------

The article table holds the basic article data:

- title
- pub date
- cost
- effort
- total_cost

Articles are associated with multiple records from the views table.

Articles published before 5/1/2010 are considered legacy data and have a legacy_data field to flag them as such. This keeps them out of some of the reporting scripts.

belongs_to :site
belongs_to :editor
belongs_to :author
has_many :views
belongs_to :content_type
belongs_to :content_source

View
----

The view table stores all the page view data. Each view includes the age of the article at the time the view record was recorded, along with the page views, bounce rate and other analytics metrics.





belongs_to :article






Author
------
has_many :articles
has_many :editors, :through => :articles




Content Source
--------------
has_many :articles
has_many :views, :through => :articles

Content Type
------------
has_many :articles
has_many :views, :through => :articles




Editor
------
has_many :articles
has_many :sites
has_many :authors, :through => :articles
has_many :articles, :through => :sites

Site
----
has_many :articles
has_many :site_stats
has_many :seo_stats
has_many :search_stats
has_many :views, :through => :articles
belongs_to :editor
has_many :authors, :through => :articles
belongs_to :vertical

