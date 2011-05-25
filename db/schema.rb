# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101102211271) do

  create_table "articles", :force => true do |t|
    t.text    "title",                                :null => false
    t.integer "content_type_id"
    t.integer "content_source_id"
    t.float   "effort",            :default => 0.0
    t.float   "cost",              :default => 0.0,   :null => false
    t.integer "author_id"
    t.text    "url"
    t.integer "container_id"
    t.date    "pub_date"
    t.integer "site_id"
    t.text    "cdev_id"
    t.boolean "flagged",           :default => false
    t.float   "total_cost"
    t.boolean "editor_updated",    :default => false
    t.integer "editor_id"
    t.text    "flag_note"
    t.boolean "legacy_content"
    t.integer "lifetime_views"
    t.float   "lifetime_revenue"
  end

  add_index "articles", ["author_id"], :name => "author_id_idx"
  add_index "articles", ["content_source_id"], :name => "content_source_id_idx"
  add_index "articles", ["content_type_id"], :name => "content_type_id_idx"
  add_index "articles", ["editor_id"], :name => "editor_id"
  add_index "articles", ["pub_date"], :name => "pub_date_idx"
  add_index "articles", ["site_id"], :name => "site_id_idx"

  create_table "authors", :force => true do |t|
    t.text    "name",                                :null => false
    t.boolean "is_internet_news", :default => false
    t.boolean "is_staff",         :default => false
    t.integer "tier",             :default => 2
  end

  create_table "complete_articles", :id => false, :force => true do |t|
    t.integer "id",                :default => 0,     :null => false
    t.text    "title",                                :null => false
    t.integer "content_type_id"
    t.integer "content_source_id"
    t.float   "effort",            :default => 0.0
    t.float   "cost",              :default => 0.0,   :null => false
    t.integer "author_id"
    t.text    "url"
    t.integer "container_id"
    t.date    "pub_date"
    t.integer "site_id"
    t.text    "cdev_id"
    t.boolean "flagged",           :default => false
    t.float   "total_cost"
    t.boolean "editor_updated",    :default => false
    t.integer "editor_id"
    t.text    "flag_note"
    t.boolean "legacy_content"
  end

  create_table "content_sources", :force => true do |t|
    t.text "name",                 :null => false
    t.text "code",  :limit => 255
    t.text "color"
  end

  create_table "content_types", :force => true do |t|
    t.text "name",                 :null => false
    t.text "code",  :limit => 255, :null => false
    t.text "color"
  end

  create_table "editors", :force => true do |t|
    t.text    "name"
    t.text    "last_name"
    t.text    "first_name",        :limit => 255
    t.text    "email"
    t.integer "group_id"
    t.float   "hourly_cost",                      :default => 40.0
    t.float   "effort_multiplier"
    t.boolean "multiplied"
  end

  create_table "groups", :force => true do |t|
    t.text "name"
    t.text "supervisor_name"
    t.text "supervisor_email"
  end

  create_table "incomplete_articles", :id => false, :force => true do |t|
    t.integer "id",                :default => 0,     :null => false
    t.text    "title",                                :null => false
    t.integer "content_type_id"
    t.integer "content_source_id"
    t.float   "effort",            :default => 0.0
    t.float   "cost",              :default => 0.0,   :null => false
    t.integer "author_id"
    t.text    "url"
    t.integer "container_id"
    t.date    "pub_date"
    t.integer "site_id"
    t.text    "cdev_id"
    t.boolean "flagged",           :default => false
    t.float   "total_cost"
    t.boolean "editor_updated",    :default => false
    t.integer "editor_id"
    t.text    "flag_note"
    t.boolean "legacy_content"
  end

  create_table "keywords", :force => true do |t|
    t.string   "word"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "report_articles", :force => true do |t|
    t.string   "title"
    t.date     "pub_date"
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
  end

  create_table "report_stats", :force => true do |t|
    t.integer  "report_article_id"
    t.date     "report_date"
    t.integer  "pageviews"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "search_stats", :force => true do |t|
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "google_us_visits"
    t.integer  "google_non_us_visits"
    t.integer  "bing_us_visits"
    t.integer  "bing_non_us_visits"
    t.integer  "yahoo_us_visits"
    t.integer  "yahoo_non_us_visits"
    t.integer  "direct_visits"
    t.integer  "referred_visits"
    t.date     "record_date"
    t.integer  "total_pageviews"
    t.integer  "total_visits"
  end

  add_index "search_stats", ["site_id"], :name => "site_id"

  create_table "seo_stats", :force => true do |t|
    t.integer  "site_id"
    t.integer  "google_pagerank"
    t.integer  "google_backlinks"
    t.integer  "yahoo_backlinks"
    t.integer  "bing_backlinks"
    t.integer  "alexa_backlinks"
    t.date     "gather_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "google_indexed_pages"
    t.integer  "yahoo_indexed_pages"
    t.integer  "bing_indexed_pages"
  end

  create_table "site_stats", :force => true do |t|
    t.integer "site_id",               :null => false
    t.date    "month",                 :null => false
    t.integer "pageviews"
    t.integer "bounces"
    t.integer "unique_pageviews"
    t.float   "bouncerate"
    t.float   "revenue"
    t.text    "content_type_report"
    t.text    "content_source_report"
    t.integer "visitors"
    t.float   "revenue_per_view"
    t.integer "pagerank"
    t.integer "agcon_bounce_rate"
    t.integer "agcon_pageviews"
  end

  create_table "sites", :force => true do |t|
    t.text    "name",                                                  :null => false
    t.boolean "is_reportable",                      :default => true
    t.boolean "is_contentengine",                   :default => false
    t.boolean "is_cdev",                            :default => false
    t.integer "channel_id"
    t.text    "legacy_channel"
    t.integer "vertical_id"
    t.text    "short_name"
    t.text    "site_domain",                                           :null => false
    t.integer "editor_id"
    t.integer "report_id"
    t.text    "analytics_profile"
    t.integer "has_agcon",             :limit => 1, :default => 0
    t.text    "agcon_news"
    t.text    "agcon_market_research"
    t.text    "agcon_white_paper"
    t.integer "high_visits",                        :default => 0
    t.integer "vertical_team_id"
    t.integer "is_core",               :limit => 1, :default => 0
    t.boolean "has_revenue"
    t.boolean "priority_report",                    :default => false
    t.integer "distinct_articles"
    t.integer "article_occurences"
    t.integer "copied_articles"
    t.float   "agcon_cost"
    t.string  "web_property_id"
  end

  create_table "social_sites", :force => true do |t|
    t.string   "name"
    t.string   "domain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "social_stats", :force => true do |t|
    t.integer  "social_site_id"
    t.integer  "site_id"
    t.date     "month"
    t.integer  "pageviews"
    t.float    "bouncerate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unique_views"
    t.integer  "entrances"
    t.integer  "bounces"
    t.integer  "visits"
  end

  create_table "texts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "article_id"
    t.text     "article_text"
  end

  create_table "topics", :force => true do |t|
    t.string   "word"
    t.boolean  "stop"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "verticals", :force => true do |t|
    t.text     "name"
    t.integer  "general_manager_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "views", :force => true do |t|
    t.integer "article_id",   :null => false
    t.integer "article_age"
    t.integer "pageviews"
    t.integer "entrances"
    t.integer "bounces"
    t.integer "unique_views"
    t.integer "flag"
    t.float   "bouncerate"
    t.date    "capture_date"
    t.float   "revenue"
  end

  add_index "views", ["article_id"], :name => "article_id_idx"

end
