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

ActiveRecord::Schema.define(:version => 20160217060025) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "blockips", :force => true do |t|
    t.string  "ip"
    t.string  "source"
    t.integer "user_id"
  end

  add_index "blockips", ["ip"], :name => "index_blockips_on_ip"

  create_table "blockips_updates", :force => true do |t|
    t.string "ip"
    t.string "source"
  end

  add_index "blockips_updates", ["ip"], :name => "index_blockips_on_ip"

  create_table "campaigns", :force => true do |t|
    t.boolean  "archived",                                         :default => false,   :null => false
    t.string   "creator",                                                               :null => false
    t.string   "safe_lp",                                                               :null => false
    t.string   "real_lp",                                                               :null => false
    t.string   "tracker",                                                               :null => false
    t.string   "sha1"
    t.string   "description"
    t.string   "rekey_from_1"
    t.string   "rekey_to_1"
    t.string   "rekey_from_2"
    t.string   "rekey_to_2"
    t.integer  "start_hour_1"
    t.integer  "end_hour_1"
    t.string   "status",                                           :default => "off",   :null => false
    t.integer  "start_count",                                      :default => 30,      :null => false
    t.boolean  "autorun",                                          :default => false,   :null => false
    t.integer  "start_hour_2"
    t.integer  "end_hour_2"
    t.string   "geocode_metro_code_list",          :limit => 1024
    t.boolean  "filter_domain_google",                             :default => false,   :null => false
    t.boolean  "filter_domain_facebook",                           :default => false,   :null => false
    t.boolean  "filter_domain_msn",                                :default => false,   :null => false
    t.string   "filter_domain_other",                              :default => "",      :null => false
    t.string   "traffic_type",                                     :default => "other", :null => false
    t.boolean  "filter_blank_referrer",                            :default => false,   :null => false
    t.boolean  "filter_organization_facebook",                     :default => false,   :null => false
    t.boolean  "filter_organization_google",                       :default => false,   :null => false
    t.boolean  "filter_organization_msn",                          :default => false,   :null => false
    t.text     "filter_organization_other"
    t.string   "geocode_country_list",             :limit => 1000
    t.boolean  "geocode_country_list_allow",                       :default => false,   :null => false
    t.boolean  "geocode_metro_code_list_allow",                    :default => false,   :null => false
    t.string   "rekey_from_3"
    t.string   "rekey_from_4"
    t.string   "rekey_from_5"
    t.string   "rekey_from_6"
    t.string   "rekey_to_3"
    t.string   "rekey_to_4"
    t.string   "rekey_to_5"
    t.string   "rekey_to_6"
    t.boolean  "mobile_filter_allow",                              :default => false
    t.boolean  "mobile_filter_mobile",                             :default => false
    t.boolean  "mobile_filter_android",                            :default => false
    t.boolean  "mobile_filter_ios",                                :default => false
    t.integer  "hit_cache_timeout",                                :default => 1,       :null => false
    t.datetime "hit_cache_start"
    t.boolean  "filter_domain_allow",                              :default => false,   :null => false
    t.boolean  "filter_broad_match",                               :default => false,   :null => false
    t.boolean  "filter_exact_match",                               :default => false,   :null => false
    t.boolean  "wifi_filter_allow",                                :default => false,   :null => false
    t.boolean  "wifi_filter_wifi",                                 :default => false,   :null => false
    t.boolean  "wifi_filter_at_t",                                 :default => false,   :null => false
    t.boolean  "wifi_filter_sprint",                               :default => false,   :null => false
    t.boolean  "wifi_filter_verizon",                              :default => false,   :null => false
    t.boolean  "wifi_filter_t_mobile",                             :default => false,   :null => false
    t.boolean  "wifi_filter_boost_mobile",                         :default => false,   :null => false
    t.boolean  "wifi_filter_metro_pcs",                            :default => false,   :null => false
    t.boolean  "browser_filter_allow",                             :default => false,   :null => false
    t.boolean  "browser_filter_firefox",                           :default => false,   :null => false
    t.boolean  "browser_filter_safari",                            :default => false,   :null => false
    t.boolean  "browser_filter_chrome",                            :default => false,   :null => false
    t.boolean  "browser_filter_internet_explorer",                 :default => false,   :null => false
    t.boolean  "browser_filter_opera",                             :default => false,   :null => false
    t.boolean  "connection_type_filter_allow",                     :default => false,   :null => false
    t.boolean  "connection_type_filter_dial_up",                   :default => false,   :null => false
    t.boolean  "connection_type_filter_cellular",                  :default => false,   :null => false
    t.boolean  "connection_type_filter_cable_dsl",                 :default => false,   :null => false
    t.boolean  "connection_type_filter_corporate",                 :default => false,   :null => false
    t.boolean  "filter_organization_allow",                        :default => false
    t.boolean  "email_notification",                               :default => false
    t.string   "email",                                            :default => ""
    t.text     "mail_description"
    t.integer  "mail_hit",                                         :default => 0,       :null => false
    t.boolean  "is_sms",                                           :default => false
    t.string   "mail_services"
    t.boolean  "sent_mail",                                        :default => false
    t.boolean  "match_timezone",                                   :default => false,   :null => false
    t.boolean  "match_time_zone_flag"
    t.string   "browser_timezone"
    t.string   "ip_timezone"
    t.integer  "user_id"
  end

  add_index "campaigns", ["archived"], :name => "index_campaigns_on_archived"
  add_index "campaigns", ["sha1"], :name => "index_campaigns_on_sha1", :unique => true

  create_table "dusoleil_errors", :force => true do |t|
    t.string   "name"
    t.integer  "campaign_id"
    t.datetime "date"
    t.string   "referer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geo_name_ip", :force => true do |t|
    t.integer "start_ip",   :null => false
    t.integer "end_ip",     :null => false
    t.integer "geoname_id"
  end

  create_table "geo_name_time_zone", :force => true do |t|
    t.integer "geoname_id", :null => false
    t.string  "timezone",   :null => false
  end

  create_table "geocode_blocks", :force => true do |t|
    t.integer "start_ipnum"
    t.integer "end_ipnum"
    t.integer "geocode_location_id"
  end

  add_index "geocode_blocks", ["geocode_location_id"], :name => "index_geocode_blocks_on_geocode_location_id"
  add_index "geocode_blocks", ["start_ipnum"], :name => "index_geocode_blocks_on_start_ipnum"

  create_table "geocode_blocks_updates", :force => true do |t|
    t.integer "start_ipnum"
    t.integer "end_ipnum"
    t.integer "geocode_location_id"
  end

  add_index "geocode_blocks_updates", ["geocode_location_id"], :name => "index_geocode_blocks_on_geocode_location_id"
  add_index "geocode_blocks_updates", ["start_ipnum"], :name => "index_geocode_blocks_on_start_ipnum"

  create_table "geocode_locations", :force => true do |t|
    t.string  "country"
    t.string  "region"
    t.string  "city"
    t.string  "postal_code"
    t.string  "lat"
    t.string  "long"
    t.integer "geocode_metro_code_id"
    t.string  "area_code"
  end

  create_table "geocode_locations_updates", :force => true do |t|
    t.string  "country"
    t.string  "region"
    t.string  "city"
    t.string  "postal_code"
    t.string  "lat"
    t.string  "long"
    t.integer "geocode_metro_code_id"
    t.string  "area_code"
  end

  create_table "geocode_metro_codes", :force => true do |t|
    t.string "metro_name"
    t.date   "last_used_at"
  end

  add_index "geocode_metro_codes", ["metro_name"], :name => "index_geocode_metro_codes_on_metro_name"

  create_table "geocode_metro_codes_from_csv", :id => false, :force => true do |t|
    t.string  "province_name"
    t.string  "metro_name"
    t.integer "metro_code"
    t.string  "criteria_id"
  end

  create_table "geocode_metro_codes_updates", :force => true do |t|
    t.string "metro_name"
    t.date   "last_used_at"
  end

  add_index "geocode_metro_codes_updates", ["metro_name"], :name => "index_geocode_metro_codes_on_metro_name"

  create_table "hit_cache_tracks", :force => true do |t|
    t.integer  "hit_id"
    t.integer  "campaign_id"
    t.string   "ip"
    t.datetime "hit_cache_start"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hit_counts", :force => true do |t|
    t.integer  "hits_total",    :null => false
    t.integer  "hits_blocked",  :null => false
    t.integer  "campaign_id",   :null => false
    t.integer  "user_agent_id", :null => false
    t.boolean  "blocked",       :null => false
    t.datetime "blocked_at",    :null => false
    t.integer  "blocked_by",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hit_counts", ["campaign_id", "user_agent_id"], :name => "index_hit_counts_on_campaign_id_and_user_agent_id", :unique => true
  add_index "hit_counts", ["campaign_id"], :name => "index_hit_counts_on_campaign_id"
  add_index "hit_counts", ["user_agent_id"], :name => "index_hit_counts_on_user_agent_id"

  create_table "hit_stats", :force => true do |t|
    t.integer "campaign_id"
    t.string  "ip"
    t.integer "hits"
  end

  create_table "hits", :force => true do |t|
    t.string   "ip"
    t.string   "user_agent"
    t.string   "referrer"
    t.string   "fullpath"
    t.datetime "created_at"
    t.boolean  "passed",                                     :null => false
    t.integer  "campaign_id",                                :null => false
    t.boolean  "analyzed",                :default => false, :null => false
    t.string   "forwarded_for"
    t.boolean  "blocked_ip",              :default => false, :null => false
    t.boolean  "blocked_proxy_ip",        :default => false, :null => false
    t.integer  "geocode_metro_code_id"
    t.boolean  "blocked_geocode",         :default => false, :null => false
    t.boolean  "blocked_domain",          :default => false, :null => false
    t.boolean  "blocked_user_agent",      :default => false, :null => false
    t.boolean  "blocked_organization",    :default => false, :null => false
    t.boolean  "blocked_mobile",          :default => false, :null => false
    t.boolean  "blocked_wifi_carrier",    :default => false, :null => false
    t.boolean  "blocked_browser",         :default => false, :null => false
    t.boolean  "blocked_referrer",        :default => false, :null => false
    t.boolean  "blocked_connection_type", :default => false, :null => false
    t.boolean  "blocked_timezone",        :default => false, :null => false
    t.string   "ip_timezone"
    t.string   "browser_timezone"
  end

  add_index "hits", ["campaign_id", "ip", "created_at"], :name => "index_hits_on_campaign_id_and_ip_and_created_at"
  add_index "hits", ["created_at"], :name => "index_hits_on_created_at"

  create_table "hits_archive", :force => true do |t|
    t.string   "ip"
    t.string   "user_agent"
    t.string   "referrer"
    t.string   "fullpath"
    t.datetime "created_at"
    t.boolean  "passed",                                   :null => false
    t.integer  "campaign_id",                              :null => false
    t.boolean  "analyzed",              :default => false, :null => false
    t.string   "forwarded_for"
    t.boolean  "blocked_ip",            :default => false, :null => false
    t.boolean  "blocked_proxy_ip",      :default => false, :null => false
    t.integer  "geocode_metro_code_id"
    t.boolean  "blocked_geocode",       :default => false, :null => false
    t.boolean  "blocked_domain",        :default => false, :null => false
    t.integer  "blocked_mobile",        :default => 0
  end

  add_index "hits_archive", ["campaign_id", "ip", "created_at"], :name => "index_hits_on_campaign_id_and_ip_and_created_at"
  add_index "hits_archive", ["created_at"], :name => "index_hits_on_created_at"

  create_table "hits_by_campaign", :id => false, :force => true do |t|
    t.integer "campaign_id",              :default => 0, :null => false
    t.integer "hits_count",  :limit => 8, :default => 0, :null => false
  end

  create_table "ip_lists", :force => true do |t|
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ipconnection_types", :force => true do |t|
    t.string   "prefix"
    t.integer  "start_ip"
    t.integer  "end_ip"
    t.string   "start_ip_addr"
    t.string   "end_ip_addr"
    t.string   "connection_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "iplocationdb_country", :primary_key => "code", :force => true do |t|
    t.string "name", :limit => 64, :null => false
  end

  create_table "iplocationdb_ip", :id => false, :force => true do |t|
    t.integer "prefix",      :limit => 1, :null => false
    t.integer "start_ip",                 :null => false
    t.integer "end_ip",                   :null => false
    t.integer "location_id",              :null => false
  end

  add_index "iplocationdb_ip", ["prefix", "start_ip", "end_ip"], :name => "prefix"

  create_table "iplocationdb_isp", :id => false, :force => true do |t|
    t.integer "prefix",   :limit => 1,  :null => false
    t.integer "start_ip",               :null => false
    t.integer "end_ip",                 :null => false
    t.string  "isp",      :limit => 64, :null => false
  end

  add_index "iplocationdb_isp", ["prefix", "start_ip", "end_ip"], :name => "prefix"

  create_table "iplocationdb_location", :force => true do |t|
    t.string  "country",    :limit => 2,                                :null => false
    t.string  "region",     :limit => 2,                                :null => false
    t.string  "city",       :limit => 64,                               :null => false
    t.string  "postalcode", :limit => 16,                               :null => false
    t.decimal "latitude",                 :precision => 8, :scale => 4, :null => false
    t.decimal "longitude",                :precision => 8, :scale => 4, :null => false
    t.string  "metrocode",  :limit => 3,                                :null => false
    t.string  "areacode",   :limit => 3,                                :null => false
  end

  create_table "iplocationdb_organization", :id => false, :force => true do |t|
    t.integer "prefix",       :limit => 1,  :null => false
    t.integer "start_ip",                   :null => false
    t.integer "end_ip",                     :null => false
    t.string  "organization", :limit => 64, :null => false
  end

  add_index "iplocationdb_organization", ["prefix", "start_ip", "end_ip"], :name => "prefix"

  create_table "iplocationdb_region", :id => false, :force => true do |t|
    t.string "country_code", :limit => 2,  :null => false
    t.string "region_code",  :limit => 2,  :null => false
    t.string "name",         :limit => 64, :null => false
  end

  create_table "stats", :force => true do |t|
    t.date    "run_at",                                  :null => false
    t.integer "hits",                     :default => 0, :null => false
    t.integer "analyzed",                 :default => 0, :null => false
    t.integer "passed",                   :default => 0, :null => false
    t.integer "campaign_id",                             :null => false
    t.integer "blocked_ip",               :default => 0, :null => false
    t.integer "blocked_proxy_ip",         :default => 0, :null => false
    t.integer "blocked_geocode",          :default => 0, :null => false
    t.integer "blocked_domain",           :default => 0, :null => false
    t.integer "blocked_mobile",           :default => 0, :null => false
    t.integer "blocked_isp_organization", :default => 0, :null => false
    t.integer "blocked_wifi_carrier",     :default => 0, :null => false
    t.integer "blocked_browser",          :default => 0, :null => false
    t.integer "blocked_referrer",         :default => 0, :null => false
    t.integer "blocked_connection_type",  :default => 0, :null => false
    t.integer "stat_timezone",            :default => 0
  end

  add_index "stats", ["campaign_id", "run_at"], :name => "index_stats_on_campaign_id_and_run_at", :unique => true

  create_table "sysconfigs", :force => true do |t|
    t.integer  "hit_cache_timeout", :default => 1,                     :null => false
    t.string   "admin_password",    :default => "",                    :null => false
    t.datetime "hit_cache_start",   :default => '2011-02-01 00:00:00', :null => false
    t.boolean  "singleton",         :default => false,                 :null => false
  end

  create_table "trackers", :force => true do |t|
    t.string  "domain",  :null => false
    t.string  "ip",      :null => false
    t.integer "user_id"
  end

  create_table "user_agents", :force => true do |t|
    t.string   "user_agent_string",               :default => "", :null => false
    t.string   "user_agent_key",    :limit => 32, :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "user_agents", ["user_agent_key"], :name => "index_user_agents_on_user_agent_key"
  add_index "user_agents", ["user_agent_key"], :name => "user_agent_key"
  add_index "user_agents", ["user_agent_string"], :name => "index_user_agents_on_user_agent_string"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_admin",                              :default => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
