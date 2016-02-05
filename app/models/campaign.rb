require 'digest/sha1'

class Campaign < ActiveRecord::Base
  cache_it :sha1, :archived

  attr_accessor :metro_codes

  has_many :hits
  has_many :stats
  has_many :user_agents, :through => :hit_counts
  has_many :hit_counts
  
  # SMS_SERVICES = [["US & Canadian Carriers", ""], ["3 River Wireless", "@sms.3rivers.net"], ["ACS Wireless", "@paging.acswireless.com"], ["Alltel", "@message.alltel.com"], ["AT&T", "@txt.att.net"], ["Bell Canada", "@txt.bellmobility.ca"], ["Bell Canada", "@bellmobility.ca"], ["Bell Mobility (Canada)", "@txt.bell.ca"], ["Bell Mobility", "@txt.bellmobility.ca"], ["Blue Sky Frog", "@blueskyfrog.com"], ["Bluegrass Cellular", "@sms.bluecell.com"], ["Boost Mobile", "@myboostmobile.com"], ["BPL Mobile", "@bplmobile.com"], ["Carolina West Wireless", "@cwwsms.com"], ["Cellular One", "@mobile.celloneusa.com"], ["Cellular South", "@csouth1.com"], ["Centennial Wireless", "@cwemail.com"], ["CenturyTel", "@messaging.centurytel.net"], ["Cingular (Now AT&T)", "@txt.att.net"], ["Clearnet", "@msg.clearnet.com"], ["Comcast", "@comcastpcs.textmsg.com"], ["Corr Wireless Communications", "@corrwireless.net"], ["Dobson", "@mobile.dobson.net"], ["Edge Wireless", "@sms.edgewireless.com"], ["Fido", "@fido.ca"], ["Golden Telecom", "@sms.goldentele.com"], ["Helio", "@messaging.sprintpcs.com"], ["Houston Cellular", "@text.houstoncellular.net"], ["Idea Cellular", "@ideacellular.net"], ["Illinois Valley Cellular", "@ivctext.com"], ["Inland Cellular Telephone", "@inlandlink.com"], ["MCI", "@pagemci.com"], ["Metrocall", "@page.metrocall.com"], ["Metrocall 2-way", "@my2way.com"], ["Metro PCS", "@mymetropcs.com"], ["Microcell", "@fido.ca"], ["Midwest Wireless", "@clearlydigital.com"], ["Mobilcomm", "@mobilecomm.net"], ["MTS", "@text.mtsmobility.com"], ["Nextel", "@messaging.nextel.com"], ["OnlineBeep", "@onlinebeep.net"], ["PCS One", "@pcsone.net"], ["President's Choice", "@txt.bell.ca"], ["Public Service Cellular", "@sms.pscel.com"], ["Qwest", "@qwestmp.com"], ["Rogers AT&T Wireless", "@pcs.rogers.com"], ["Rogers Canada", "@pcs.rogers.com"], ["Satellink", ".pageme@satellink.net"], ["Southwestern Bell", "@email.swbw.com"], ["Sprint", "@messaging.sprintpcs.com"], ["Sumcom", "@tms.suncom.com"], ["Surewest Communicaitons", "@mobile.surewest.com"], ["T-Mobile", "@tmomail.net"], ["Telus", "@msg.telus.com"], ["Tracfone", "@txt.att.net"], ["Triton", "@tms.suncom.com"], ["Unicel", "@utext.com"], ["US Cellular", "@email.uscc.net"], ["Solo Mobile", "@txt.bell.ca"], ["Sprint", "@messaging.sprintpcs.com"], ["Sumcom", "@tms.suncom.com"], ["Surewest Communicaitons", "@mobile.surewest.com"], ["T-Mobile", "@tmomail.net"], ["Telus", "@msg.telus.com"], ["Triton", "@tms.suncom.com"], ["Unicel", "@utext.com"], ["US Cellular", "@email.uscc.net"], ["US West", "@uswestdatamail.com"], ["Verizon", "@vtext.com"], ["Virgin Mobile", "@vmobl.com"], ["Virgin Mobile Canada", "@vmobile.ca"], ["West Central Wireless", "@sms.wcc.net"], ["Western Wireless", "@cellularonewest.com"], ["International Carriers", ""], ["Chennai RPG Cellular", "@rpgmail.net"], ["Chennai Skycell / Airtel", "@airtelchennai.com"], ["Comviq", "@sms.comviq.se"], ["Delhi Aritel", "@airtelmail.com"], ["Delhi Hutch", "@delhi.hutch.co.in"], ["DT T-Mobile", "@t-mobile-sms.de"], ["Dutchtone / Orange-NL", "@sms.orange.nl"], ["EMT", "@sms.emt.ee"], ["Escotel", "@escotelmobile.com"], ["German T-Mobile", "@t-mobile-sms.de"], ["Goa BPLMobil", "@bplmobile.com"], ["Golden Telecom", "@sms.goldentele.com"], ["Gujarat Celforce", "@celforce.com"], ["JSM Tele-Page", "@jsmtel.com"], ["Kerala Escotel", "@escotelmobile.com"], ["Kolkata Airtel", "@airtelkol.com"], ["Kyivstar", "@smsmail.lmt.lv"], ["Lauttamus Communication", "@e-page.net"], ["LMT", "@smsmail.lmt.lv"], ["Maharashtra BPL Mobile", "@bplmobile.com"], ["Maharashtra Idea Cellular", "@ideacellular.net"], ["Manitoba Telecom Systems", "@text.mtsmobility.com"], ["Meteor", "@mymeteor.ie"], ["MiWorld", "@m1.com.sg"], ["Mobileone", "@m1.com.sg"], ["Mobilfone", "@page.mobilfone.com"], ["Mobility Bermuda", "@ml.bm"], ["Mobistar Belgium", "@mobistar.be"], ["Mobitel Tanzania", "@sms.co.tz"], ["Mobtel Srbija", "@mobtel.co.yu"], ["Movistar", "@correo.movistar.net"], ["Mumbai BPL Mobile", "@bplmobile.com"], ["Netcom", "@sms.netcom.no"], ["Ntelos", "@pcs.ntelos.com"], ["O2", "@o2.co.uk"], ["O2", "@o2imail.co.uk"], ["O2 (M-mail)", "@mmail.co.uk"], ["One Connect Austria", "@onemail.at"], ["OnlineBeep", "@onlinebeep.net"], ["Optus Mobile", "@optusmobile.com.au"], ["Orange", "@orange.net"], ["Orange Mumbai", "@orangemail.co.in"], ["Orange NL / Dutchtone", "@sms.orange.nl"], ["Oskar", "@mujoskar.cz"], ["P&T Luxembourg", "@sms.luxgsm.lu"], ["Personal Communication", "@pcom.ru"], ["Pondicherry BPL Mobile", "@bplmobile.com"], ["Primtel", "@sms.primtel.ru"], ["Safaricom", "@safaricomsms.com"], ["Satelindo GSM", "@satelindogsm.com"], ["SCS-900", "@scs-900.ru"], ["SFR France", "@sfr.fr"], ["Simple Freedom", "@text.simplefreedom.net"], ["Smart Telecom", "@mysmart.mymobile.ph"], ["Southern LINC", "@page.southernlinc.com"], ["Sunrise Mobile", "@mysunrise.ch"], ["Sunrise Mobile", "@swmsg.com"], ["Surewest Communications", "@freesurf.ch"], ["Swisscom", "@bluewin.ch"], ["T-Mobile Austria", "@sms.t-mobile.at"], ["T-Mobile Germany", "@t-d1-sms.de"], ["T-Mobile UK", "@t-mobile.uk.net"], ["Tamil Nadu BPL Mobile", "@bplmobile.com"], ["Tele2 Latvia", "@sms.tele2.lv"], ["Telefonica Movistar", "@movistar.net"], ["Telenor", "@mobilpost.no"], ["Teletouch", "@pageme.teletouch.com"], ["Telia Denmark", "@gsm1800.telia.dk"], ["TIM", "@timnet.com"], ["TSR Wireless", "@alphame.com"], ["UMC", "@sms.umc.com.ua"], ["Uraltel", "@sms.uraltel.ru"], ["Uttar Pradesh Escotel", "@escotelmobile.com"], ["Vessotel", "@pager.irkutsk.ru"], ["Vodafone Italy", "@sms.vodafone.it"], ["Vodafone Japan", "@c.vodafone.ne.jp"], ["Vodafone Japan", "@h.vodafone.ne.jp"], ["Vodafone Japan", "@t.vodafone.ne.jp"], ["Vodafone UK", "@vodafone.net"], ["Wyndtell", "@wyndtell.com"], ["Old US & Canadian Carriers (Most Not In Use)", ""], ["Advantage Communications", "@advantagepaging.com"], ["Airtouch Pagers", "@myairmail.com"], ["AlphaNow", "@alphanow.net"], ["Ameritech Paging", "@paging.acswireless.com"], ["American Messaging", "@page.americanmessaging.net"], ["Ameritech Clearpath", "@clearpath.acswireless.com"], ["Arch Pagers (PageNet)", "@archwireless.net"], ["AT&T", "@mobile.att.net"], ["AT&T Free2Go", "@mmode.com"], ["AT&T PCS", "@mobile.att.net"], ["AT&T Pocketnet PCS", "@dpcs.mobile.att.net"], ["Beepwear", "@beepwear.net"], ["Bell Atlantic", "@message.bam.com"], ["Bell South", "@wireless.bellsouth.com"], ["Bell South (Blackberry)", "@bellsouthtips.com"], ["Bell South Mobility", "@blsdcs.net"], ["Cellular One (East Coast)", "@phone.cellone.net"], ["Cellular One (South West)", "@swmsg.com"], ["Cellular One", "@cellularone.txtmsg.com"], ["Cellular One", "@cellularone.textmsg.com"], ["Cellular One", "@cell1.textmsg.com"], ["Cellular One", "@sbcemail.com"], ["Cellular One (West)", "@mycellone.com"], ["Central Vermont Communications", "@cvcpaging.com"], ["Cingular", "@cingularme.com"], ["Communication Specialists", "@pageme.comspeco.net"], ["Cook Paging", "@cookmail.com"], ["Corr Wireless Communications", "@corrwireless.net"], ["Digi-Page / Page Kansas", "@page.hit.net"], ["Galaxy Corporation", "@sendabeep.net"], ["GCS Paging", "@webpager.us"], ["GrayLink / Porta-Phone", "@epage.porta-phone.com"], ["GTE", "@airmessage.net"], ["GTE", "@gte.pagegate.net"], ["GTE", "@messagealert.com"], ["Infopage Systems", "@page.infopagesystems.com"], ["Indiana Paging Co", "@inlandlink.com"], ["MCI", "@pagemci.com"], ["Metrocall", "@page.metrocall.com"], ["Mobilecom PA", "@page.mobilcom.net"], ["Morris Wireless", "@beepone.net"], ["Motient", "@isp.com"], ["Nextel", "@page.nextel.com"], ["Omnipoint", "@omnipointpcs.com"], ["Pacific Bell", "@pacbellpcs.net"], ["PageMart", "@pagemart.net"], ["PageMart Canada", "@pmcl.net"], ["PageNet Canada", "@pagegate.pagenet.ca"], ["PageOne Northwest", "@page1nw.com"], ["PCS One", "@pcsone.net"], ["Powertel", "@voicestream.net"], ["Price Communications", "@mobilecell1se.com"], ["Primeco", "@email.uscc.net"], ["ProPage", "@page.propage.net"], ["Qualcomm", "@pager.qualcomm.com"], ["RAM Page", "@ram-page.com"], ["SBC Ameritech Paging", "@paging.acswireless.com"], ["Skytel Pagers", "@email.skytel.com"], ["ST Paging", "@page.stpaging.com"], ["Verizon Pagers", "@myairmail.com"], ["Verizon PCS", "@myvzw.com"], ["VoiceStream", "@voicestream.net"], ["WebLink Wireless", "@@airmessage.net"], ["WebLink Wireless", "@pagemart.net"], ["West Central Wireless", "@sms.wcc.net"]]
  SMS_SERVICES =[
                  ["US & Canadian Carriers", 
                    [["3 River Wireless", "@sms.3rivers.net"], ["ACS Wireless", "@paging.acswireless.com"], ["Alltel", "@message.alltel.com"], ["AT&T", "@txt.att.net"], ["Bell Canada", "@txt.bellmobility.ca"], ["Bell Canada", "@bellmobility.ca"], ["Bell Mobility (Canada)", "@txt.bell.ca"], ["Bell Mobility", "@txt.bellmobility.ca"], ["Blue Sky Frog", "@blueskyfrog.com"], ["Bluegrass Cellular", "@sms.bluecell.com"], ["Boost Mobile", "@myboostmobile.com"], ["BPL Mobile", "@bplmobile.com"], ["Carolina West Wireless", "@cwwsms.com"], ["Cellular One", "@mobile.celloneusa.com"], ["Cellular South", "@csouth1.com"], ["Centennial Wireless", "@cwemail.com"], ["CenturyTel", "@messaging.centurytel.net"], ["Cingular (Now AT&T)", "@txt.att.net"], ["Clearnet", "@msg.clearnet.com"], ["Comcast", "@comcastpcs.textmsg.com"], ["Corr Wireless Communications", "@corrwireless.net"], ["Dobson", "@mobile.dobson.net"], ["Edge Wireless", "@sms.edgewireless.com"], ["Fido", "@fido.ca"], ["Golden Telecom", "@sms.goldentele.com"], ["Helio", "@messaging.sprintpcs.com"], ["Houston Cellular", "@text.houstoncellular.net"], ["Idea Cellular", "@ideacellular.net"], ["Illinois Valley Cellular", "@ivctext.com"], ["Inland Cellular Telephone", "@inlandlink.com"], ["MCI", "@pagemci.com"], ["Metrocall", "@page.metrocall.com"], ["Metrocall 2-way", "@my2way.com"], ["Metro PCS", "@mymetropcs.com"], ["Microcell", "@fido.ca"], ["Midwest Wireless", "@clearlydigital.com"], ["Mobilcomm", "@mobilecomm.net"], ["MTS", "@text.mtsmobility.com"], ["Nextel", "@messaging.nextel.com"], ["OnlineBeep", "@onlinebeep.net"], ["PCS One", "@pcsone.net"], ["President's Choice", "@txt.bell.ca"], ["Public Service Cellular", "@sms.pscel.com"], ["Qwest", "@qwestmp.com"], ["Rogers AT&T Wireless", "@pcs.rogers.com"], ["Rogers Canada", "@pcs.rogers.com"], ["Satellink", ".pageme@satellink.net"], ["Southwestern Bell", "@email.swbw.com"], ["Sprint", "@messaging.sprintpcs.com"], ["Sumcom", "@tms.suncom.com"], ["Surewest Communicaitons", "@mobile.surewest.com"], ["T-Mobile", "@tmomail.net"], ["Telus", "@msg.telus.com"], ["Tracfone", "@txt.att.net"], ["Triton", "@tms.suncom.com"], ["Unicel", "@utext.com"], ["US Cellular", "@email.uscc.net"], ["Solo Mobile", "@txt.bell.ca"], ["Sprint", "@messaging.sprintpcs.com"], ["Sumcom", "@tms.suncom.com"], ["Surewest Communicaitons", "@mobile.surewest.com"], ["T-Mobile", "@tmomail.net"], ["Telus", "@msg.telus.com"], ["Triton", "@tms.suncom.com"], ["Unicel", "@utext.com"], ["US Cellular", "@email.uscc.net"], ["US West", "@uswestdatamail.com"], ["Verizon", "@vtext.com"], ["Virgin Mobile", "@vmobl.com"], ["Virgin Mobile Canada", "@vmobile.ca"], ["West Central Wireless", "@sms.wcc.net"], ["Western Wireless", "@cellularonewest.com"]]
                  ], 
                  ["International Carriers", 
                    [["Chennai RPG Cellular", "@rpgmail.net"], ["Chennai Skycell / Airtel", "@airtelchennai.com"], ["Comviq", "@sms.comviq.se"], ["Delhi Aritel", "@airtelmail.com"], ["Delhi Hutch", "@delhi.hutch.co.in"], ["DT T-Mobile", "@t-mobile-sms.de"], ["Dutchtone / Orange-NL", "@sms.orange.nl"], ["EMT", "@sms.emt.ee"], ["Escotel", "@escotelmobile.com"], ["German T-Mobile", "@t-mobile-sms.de"], ["Goa BPLMobil", "@bplmobile.com"], ["Golden Telecom", "@sms.goldentele.com"], ["Gujarat Celforce", "@celforce.com"], ["JSM Tele-Page", "@jsmtel.com"], ["Kerala Escotel", "@escotelmobile.com"], ["Kolkata Airtel", "@airtelkol.com"], ["Kyivstar", "@smsmail.lmt.lv"], ["Lauttamus Communication", "@e-page.net"], ["LMT", "@smsmail.lmt.lv"], ["Maharashtra BPL Mobile", "@bplmobile.com"], ["Maharashtra Idea Cellular", "@ideacellular.net"], ["Manitoba Telecom Systems", "@text.mtsmobility.com"], ["Meteor", "@mymeteor.ie"], ["MiWorld", "@m1.com.sg"], ["Mobileone", "@m1.com.sg"], ["Mobilfone", "@page.mobilfone.com"], ["Mobility Bermuda", "@ml.bm"], ["Mobistar Belgium", "@mobistar.be"], ["Mobitel Tanzania", "@sms.co.tz"], ["Mobtel Srbija", "@mobtel.co.yu"], ["Movistar", "@correo.movistar.net"], ["Mumbai BPL Mobile", "@bplmobile.com"], ["Netcom", "@sms.netcom.no"], ["Ntelos", "@pcs.ntelos.com"], ["O2", "@o2.co.uk"], ["O2", "@o2imail.co.uk"], ["O2 (M-mail)", "@mmail.co.uk"], ["One Connect Austria", "@onemail.at"], ["OnlineBeep", "@onlinebeep.net"], ["Optus Mobile", "@optusmobile.com.au"], ["Orange", "@orange.net"], ["Orange Mumbai", "@orangemail.co.in"], ["Orange NL / Dutchtone", "@sms.orange.nl"], ["Oskar", "@mujoskar.cz"], ["P&T Luxembourg", "@sms.luxgsm.lu"], ["Personal Communication", "@pcom.ru"], ["Pondicherry BPL Mobile", "@bplmobile.com"], ["Primtel", "@sms.primtel.ru"], ["Safaricom", "@safaricomsms.com"], ["Satelindo GSM", "@satelindogsm.com"], ["SCS-900", "@scs-900.ru"], ["SFR France", "@sfr.fr"], ["Simple Freedom", "@text.simplefreedom.net"], ["Smart Telecom", "@mysmart.mymobile.ph"], ["Southern LINC", "@page.southernlinc.com"], ["Sunrise Mobile", "@mysunrise.ch"], ["Sunrise Mobile", "@swmsg.com"], ["Surewest Communications", "@freesurf.ch"], ["Swisscom", "@bluewin.ch"], ["T-Mobile Austria", "@sms.t-mobile.at"], ["T-Mobile Germany", "@t-d1-sms.de"], ["T-Mobile UK", "@t-mobile.uk.net"], ["Tamil Nadu BPL Mobile", "@bplmobile.com"], ["Tele2 Latvia", "@sms.tele2.lv"], ["Telefonica Movistar", "@movistar.net"], ["Telenor", "@mobilpost.no"], ["Teletouch", "@pageme.teletouch.com"], ["Telia Denmark", "@gsm1800.telia.dk"], ["TIM", "@timnet.com"], ["TSR Wireless", "@alphame.com"], ["UMC", "@sms.umc.com.ua"], ["Uraltel", "@sms.uraltel.ru"], ["Uttar Pradesh Escotel", "@escotelmobile.com"], ["Vessotel", "@pager.irkutsk.ru"], ["Vodafone Italy", "@sms.vodafone.it"], ["Vodafone Japan", "@c.vodafone.ne.jp"], ["Vodafone Japan", "@h.vodafone.ne.jp"], ["Vodafone Japan", "@t.vodafone.ne.jp"], ["Vodafone UK", "@vodafone.net"], ["Wyndtell", "@wyndtell.com"]]
                  ], 
                  ["Old US & Canadian Carriers (Most Not In Use)", 
                    [["Advantage Communications", "@advantagepaging.com"], ["Airtouch Pagers", "@myairmail.com"], ["AlphaNow", "@alphanow.net"], ["Ameritech Paging", "@paging.acswireless.com"], ["American Messaging", "@page.americanmessaging.net"], ["Ameritech Clearpath", "@clearpath.acswireless.com"], ["Arch Pagers (PageNet)", "@archwireless.net"], ["AT&T", "@mobile.att.net"], ["AT&T Free2Go", "@mmode.com"], ["AT&T PCS", "@mobile.att.net"], ["AT&T Pocketnet PCS", "@dpcs.mobile.att.net"], ["Beepwear", "@beepwear.net"], ["Bell Atlantic", "@message.bam.com"], ["Bell South", "@wireless.bellsouth.com"], ["Bell South (Blackberry)", "@bellsouthtips.com"], ["Bell South Mobility", "@blsdcs.net"], ["Cellular One (East Coast)", "@phone.cellone.net"], ["Cellular One (South West)", "@swmsg.com"], ["Cellular One", "@cellularone.txtmsg.com"], ["Cellular One", "@cellularone.textmsg.com"], ["Cellular One", "@cell1.textmsg.com"], ["Cellular One", "@sbcemail.com"], ["Cellular One (West)", "@mycellone.com"], ["Central Vermont Communications", "@cvcpaging.com"], ["Cingular", "@cingularme.com"], ["Communication Specialists", "@pageme.comspeco.net"], ["Cook Paging", "@cookmail.com"], ["Corr Wireless Communications", "@corrwireless.net"], ["Digi-Page / Page Kansas", "@page.hit.net"], ["Galaxy Corporation", "@sendabeep.net"], ["GCS Paging", "@webpager.us"], ["GrayLink / Porta-Phone", "@epage.porta-phone.com"], ["GTE", "@airmessage.net"], ["GTE", "@gte.pagegate.net"], ["GTE", "@messagealert.com"], ["Infopage Systems", "@page.infopagesystems.com"], ["Indiana Paging Co", "@inlandlink.com"], ["MCI", "@pagemci.com"], ["Metrocall", "@page.metrocall.com"], ["Mobilecom PA", "@page.mobilcom.net"], ["Morris Wireless", "@beepone.net"], ["Motient", "@isp.com"], ["Nextel", "@page.nextel.com"], ["Omnipoint", "@omnipointpcs.com"], ["Pacific Bell", "@pacbellpcs.net"], ["PageMart", "@pagemart.net"], ["PageMart Canada", "@pmcl.net"], ["PageNet Canada", "@pagegate.pagenet.ca"], ["PageOne Northwest", "@page1nw.com"], ["PCS One", "@pcsone.net"], ["Powertel", "@voicestream.net"], ["Price Communications", "@mobilecell1se.com"], ["Primeco", "@email.uscc.net"], ["ProPage", "@page.propage.net"], ["Qualcomm", "@pager.qualcomm.com"], ["RAM Page", "@ram-page.com"], ["SBC Ameritech Paging", "@paging.acswireless.com"], ["Skytel Pagers", "@email.skytel.com"], ["ST Paging", "@page.stpaging.com"], ["Verizon Pagers", "@myairmail.com"], ["Verizon PCS", "@myvzw.com"], ["VoiceStream", "@voicestream.net"], ["WebLink Wireless", "@@airmessage.net"], ["WebLink Wireless", "@pagemart.net"], ["West Central Wireless", "@sms.wcc.net"]]
                  ]
                ]
  
  CREATORS = %w( owen tyler tom guest debug )
  STATUS_VALUES = %w( on off )
  TRAFFIC_TYPE_VALUES = %w( Facebook Google MSN Display PPV Mobile other )

  validates :creator, :presence => true, :inclusion => { :in => CREATORS }
  validates :safe_lp, :presence => true, :url_format => true
  validates :real_lp, :presence => true, :url_format => true
  # validates :tracker, :presence => true, :inclusion => { :in => Tracker::AllDomains, :on => :create }
  validates :tracker, :presence => true
  validates :status, :presence => true, :inclusion => { :in => STATUS_VALUES }
  validates :start_count, :numericality => { :if => Proc.new {|c| c.status == "autorun"}, :only_integer => true }

  REKEY_MSG = "must use only word characters"
  validates :rekey_from_1, :presence => { :if => :rekey_to_1? }, 
    :format => { :allow_blank => true, :with => /^\w+$/, :message => REKEY_MSG }
  validates :rekey_from_2, :presence => { :if => :rekey_to_2? }, 
    :format => { :allow_blank => true, :with => /^\w+$/, :message => REKEY_MSG }
  validates :rekey_from_3, :presence => { :if => :rekey_to_3? }, 
    :format => { :allow_blank => true, :with => /^\w+$/, :message => REKEY_MSG }
  validates :rekey_from_4, :presence => { :if => :rekey_to_4? }, 
    :format => { :allow_blank => true, :with => /^\w+$/, :message => REKEY_MSG }
  validates :rekey_from_5, :presence => { :if => :rekey_to_5? }, 
    :format => { :allow_blank => true, :with => /^\w+$/, :message => REKEY_MSG }
  validates :rekey_from_6, :presence => { :if => :rekey_to_6? }, 
    :format => { :allow_blank => true, :with => /^\w+$/, :message => REKEY_MSG }

  validates :rekey_to_1, :presence => { :if => :rekey_from_1? }, 
    :format => { :allow_blank => true, :with => /^\w+$/, :message => REKEY_MSG }
  validates :rekey_to_2, :presence => { :if => :rekey_from_2? }, 
    :format => { :allow_blank => true, :with => /^\w+$/, :message => REKEY_MSG }
  validates :rekey_to_3, :presence => { :if => :rekey_from_3? }, 
    :format => { :allow_blank => true, :with => /^\w+$/, :message => REKEY_MSG }
  validates :rekey_to_4, :presence => { :if => :rekey_from_4? }, 
    :format => { :allow_blank => true, :with => /^\w+$/, :message => REKEY_MSG }
  validates :rekey_to_5, :presence => { :if => :rekey_from_5? }, 
    :format => { :allow_blank => true, :with => /^\w+$/, :message => REKEY_MSG }
  validates :rekey_to_6, :presence => { :if => :rekey_from_6? }, 
    :format => { :allow_blank => true, :with => /^\w+$/, :message => REKEY_MSG }

  validate do |campaign|
    if campaign.rekey_from_1? and campaign.rekey_from_2? and campaign.rekey_from_1 == campaign.rekey_from_2
      campaign.errors.add(:rekey_from_2, "can't be the same as Re-key from 1")
    end
  end

  validates :rekey_from_1, :exclusion => { :in => ["sha1", "h", "id"], :message => "cannot use 'sha1', 'h', or 'id'" }
  validates :rekey_from_2, :exclusion => { :in => ["sha1", "h", "id"], :message => "cannot use 'sha1', 'h', or 'id'" }
  validates :rekey_from_3, :exclusion => { :in => ["sha1", "h", "id"], :message => "cannot use 'sha1', 'h', or 'id'" }
  validates :rekey_from_4, :exclusion => { :in => ["sha1", "h", "id"], :message => "cannot use 'sha1', 'h', or 'id'" }
  validates :rekey_from_5, :exclusion => { :in => ["sha1", "h", "id"], :message => "cannot use 'sha1', 'h', or 'id'" }
  validates :rekey_from_6, :exclusion => { :in => ["sha1", "h", "id"], :message => "cannot use 'sha1', 'h', or 'id'" }

  HOUR_MSG = "must be in 0..24"
  validates :start_hour_1, :presence => { :if => :end_hour_1? }, 
    :inclusion => { :allow_blank => true, :in => 0..24, :message => HOUR_MSG }
  validates :end_hour_1, :presence => { :if => :start_hour_1? }, 
    :inclusion => { :allow_blank => true, :in => 0..24, :message => HOUR_MSG }
  validates :end_hour_1, :numericality => { :if => :start_hour_1?, :allow_blank => true, 
    :greater_than => :start_hour_1, :message => "must be greater than start hour" }

  validates :start_hour_2, :presence => { :if => :end_hour_2? }, 
    :inclusion => { :allow_blank => true, :in => 0..24, :message => HOUR_MSG }
  validates :end_hour_2, :presence => { :if => :start_hour_2? }, 
    :inclusion => { :allow_blank => true, :in => 0..24, :message => HOUR_MSG }
  validates :end_hour_2, :numericality => { :if => :start_hour_2?, :allow_blank => true, 
    :greater_than => :start_hour_2, :message => "must be greater than start hour" }
  after_save :generate_sha
    
  # for metro_codes
  def metro_codes
    @metro_codes ||= Hash[*(geocode_metro_code_list || "").split(",").map{|c|[c.to_i,"1"]}.flatten]
  end

  def metro_codes=(val)
    @metro_code_ids = val.keys
    self.geocode_metro_code_list = @metro_code_ids.join(",")
  end
  
  after_save :touch_metro_codes
  def touch_metro_codes
    if @metro_code_ids
      @metro_code_ids.each do |id|
        metro_code = GeocodeMetroCode.where(:id => id).first
        metro_code.last_used_at = Date.today
        metro_code.save
      end
    end
  end
  
  def all_metro_codes_partition
    recent = Date.today - 90
    all_metro_codes = GeocodeMetroCode.order(:metro_name).all.group_by do |metro_code|
      !!(metro_codes[metro_code.id] || (metro_code.last_used_at && metro_code.last_used_at > recent))
    end
    [all_metro_codes[true] || [], all_metro_codes[false] || []]
  end
  
  # same for countries
  def countries
    @countries ||= Hash[*(geocode_country_list || "").split(",").map{|c|[c,"1"]}.flatten]
  end
  
  def status_flags
    flags = ""
    flags += "O" if status == "on"
    flags += "X" unless within_day_part?
    flags += "A" if autorun
    flags += "(#{countdown})" if autorun and not started?
    flags += "S" if started?
    return flags
  end
  
  def formatted_flag_campaign_on
    "<span class='label label-success'>ON</span> "
  end
  
  def formatted_flag_not_in_day_part
    formatted_flag = "<span class='label' "
    formatted_flag += "rel='popover' "
    formatted_flag += "data-original-title='Day-Part(s) Blocking Hits' "
    formatted_flag += "data-content='Current Time, <strong>"
    formatted_flag += Time.now.strftime('%H:%M:%S')
    formatted_flag += "</strong>, is not allowed."
    if start_hour_1 && end_hour_1
      formatted_flag += "<br >"
      formatted_flag += "Day-Part 1 Hours: "
      formatted_flag += '%02d:00' % start_hour_1
      formatted_flag += " to "
      formatted_flag += '%02d:00' % end_hour_1
      formatted_flag += ". "
    end
    if start_hour_2 && end_hour_2
      formatted_flag += "<br />"
      formatted_flag += "Day-Part 2 Hours: "
      formatted_flag += '%02d:00' % start_hour_2
      formatted_flag += " to "
      formatted_flag += '%02d:00' % end_hour_2
      formatted_flag += ". "
    end
    formatted_flag += "' " # end of data-content param (within span tag)
    formatted_flag += "data-html='true' "
    formatted_flag += ">X</span> "
    return formatted_flag
  end

  def formatted_flag_autorun
     formatted_flag = "<span class='label' "
     formatted_flag += "rel='popover' data-original-title='Autorun Enabled' "
     formatted_flag += "data-content='Status: #{ started? ? 'Count Complete' : ('Counting down from ' + start_count.to_s) }' "
     formatted_flag += ">"
     formatted_flag += "A" 
     formatted_flag += "(#{countdown})" if not started?
     formatted_flag += "</span> "
     return formatted_flag
  end
  
  def formatted_flag_started
    "<span class='label' rel='tooltip' data-original-title='Campaign has Started'>S</span>"
  end

  def formatted_status_flags
    formatted_flags = ""
    # formatted_flags += formatted_flag_campaign_on if status == "on"
    formatted_flags += formatted_flag_not_in_day_part unless within_day_part?
    formatted_flags += formatted_flag_autorun if autorun
    formatted_flags += formatted_flag_started if started?
    return formatted_flags
  end

  def started?
    start_count.nil? or Stat.today(id).hits >= start_count 
  end

  def countdown
    return "" unless autorun and not started?
    return (start_count - Stat.today(id).hits).to_s
  end

  def url(options = {})
    format = ".js" if options[:js]
    url = "http://#{tracker}/#{format}?h=#{self.sha1}"
    url += "&#{rekey_from_1}=" if rekey_from_1.present?
    url += "&#{rekey_from_2}=" if rekey_from_2.present?
    url += "&#{rekey_from_3}=" if rekey_from_3.present?
    url += "&#{rekey_from_4}=" if rekey_from_4.present?
    url += "&#{rekey_from_5}=" if rekey_from_5.present?
    url += "&#{rekey_from_6}=" if rekey_from_6.present?
    return url
  end

  def script_tag
    return "<script src=\"#{url(:js => true)}\"></script>"
  end

  def rekeyed_lp(from, attr)
    lp = case attr
    when :real_lp then real_lp
    when :safe_lp then safe_lp
    end
    from_uri = URI.parse(from)
    from_params = Hash[URI.decode_www_form(from_uri.query || "")]
    lp_uri = URI.parse(lp)
    lp_params = Hash[URI.decode_www_form(lp_uri.query || "")]
    lp_params[rekey_to_1] = from_params[rekey_from_1] if rekey_from_1.present? and from_params[rekey_from_1]
    lp_params[rekey_to_2] = from_params[rekey_from_2] if rekey_from_2.present? and from_params[rekey_from_2]
    lp_params[rekey_to_3] = from_params[rekey_from_3] if rekey_from_3.present? and from_params[rekey_from_3]
    lp_params[rekey_to_4] = from_params[rekey_from_4] if rekey_from_4.present? and from_params[rekey_from_4]
    lp_params[rekey_to_5] = from_params[rekey_from_5] if rekey_from_5.present? and from_params[rekey_from_5]
    lp_params[rekey_to_6] = from_params[rekey_from_6] if rekey_from_6.present? and from_params[rekey_from_6]
    lp_uri.query = URI.encode_www_form(lp_params.to_a)
    return lp_uri.to_s
  rescue
    return lp
  end

  def among_recent_hits?(ip)
    hit = Hit.cache_it.read(:ip => ip, :campaign_id => id)
    return hit && hit.created_at > Sysconfig.singleton.hit_cache_start
  end

  def within_day_part?
    hour = Time.now.hour
    range_1 = (start_hour_1...end_hour_1) if start_hour_1 and end_hour_1
    range_2 = (start_hour_2...end_hour_2) if start_hour_2 and end_hour_2
    return true unless range_1 or range_2
    return true if (range_1 and range_1.include?(hour)) or (range_2 and range_2.include?(hour))
  end
  
  FACEBOOK_DOMAINS = %w( facebook.com )
  GOOGLE_DOMAINS   = %w( google.com gmail.com )
  MSN_DOMAINS      = %w( msn.com microsoft.com  )
  
  def referer_domain_filter_active?
    return true if ( ( filter_domain_facebook? || filter_domain_google? || filter_domain_msn? ) || filter_domain_other.length > 0 )
  end
  
  def all_referer_domains_allowed
    filter = []
    filter = filter + FACEBOOK_DOMAINS  if filter_domain_facebook
    filter = filter + GOOGLE_DOMAINS    if filter_domain_google
    filter = filter + MSN_DOMAINS       if filter_domain_msn
    filter = filter + filter_domain_other.split(/ *, */) if filter_domain_other
    return filter
  end
  
  def referer_domain_allowed?(url)
    # FALSE = fails filter, BLOCKED
    # TRUE = passes filter, ALLOWED
    
    # TEST 1: IF filter is OFF, then the hit automatically should PASS, otherwise, move to next test
    # return true unless self.referer_domain_filter_active?
    
    # TEST 2: Return FALSE UNLESS host is present in referer, if present, move to next test
    host = URI.parse(url).host rescue (return false)  # get full host (www.google.com) from url (http://www.google.com)

    # TEST 3: If no host present, PASS or BLOCK according to campaign setting. includes case of referrer == '/'
    unless host
      return !self.filter_blank_referrer
    else
      true
    end
    
    # TEST 4: match host against allowed domains,  if it matches, then PASS, otherwise, FAIL
    # filter = all_referer_domains_allowed                            # define filter array of all allowed domains
    # return filter.any? {|domain| match_domain?(domain, host)}   # returns TRUE if match, otherwise FALSE
        
  end
  
  def hit_counts_total
    hit_counts.sum(:hits_total)
  end
  
  def self.search(search_key)
    attrs = self.new.attributes
    qry = []
    search_key = search_key.downcase
    attrs.each do |key, val|
      qry << "LOWER(#{key}) LIKE '%#{search_key}%'"
    end
    self.where(qry.join(" OR "))
  end

  def self.check_timezone(ip)
    require 'net/http'
    require 'net/https'
    url = URI.parse("http://ip-api.com/json/#{ip}")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) { |http|
      http.request(req)
    }
    response = res.body
    if response.present?
      @response = JSON.parse(response)
    end
    if @response['timezone'].present?
      return @response['timezone']
    else
      lat = @response['lat']
      lon = @response['lon']
      geo = "https://maps.googleapis.com/maps/api/timezone/json?location=#{lat},#{lon}&timestamp=#{Date.today.to_time.to_i}"
      url1 = URI.escape(geo)
      resp = RestClient.get(url1)
      result = JSON.parse(resp.body)
      return result['timeZoneId']
    end
  end
  protected
  
  def match_domain?(domain, host)
    domain_array = domain.split(/\./)
    host_array = host.split(/\./)
    return domain_array == host_array.slice(-domain_array.size, domain_array.size)
  end

  SALT = "99283hf23uhf"
  def generate_sha
    return true if self.sha1.present?
    hashtext = "#{SALT}:#{id}:#{tracker}"
    self.sha1 = Digest::SHA1.hexdigest hashtext
    self.save
  end
end
