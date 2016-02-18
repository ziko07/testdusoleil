class CampaignMailer < ActionMailer::Base
  default from: "admin@tracker.com"
  
  def notification(campaign, status)
    if status == 0
      subject = "Your campaign status was chnaged to ON"
    else
      subject = "Your campaign received 10 hits"
    end     
    campaign.email.split(",").each do |mail|
      break if mail.blank?
      mail = mail.delete(" ")
      if campaign.is_sms == true
        campaign.mail_services.split(",").each do |mail_service|
          sms_mail = "#{mail}#{mail_service}"
          p ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
          p mail
          p mail_service
          p sms_mail
          CampaignMailer.campaign_notification(sms_mail, campaign.description, subject, campaign.id).deliver
        end        
      else
        CampaignMailer.campaign_notification(mail, campaign.description, subject,campaign.id).deliver
      end
    end
  end


  def password_changed(email,password)
    @email =  email
    @password = password
    mail to: email, subject: "Your password has changed"
  end

  def create_user(email,password)
    @email =  email
    @password = password
    mail to: email, subject: "New account has been created"
  end

  def campaign_notification(mail, description, subject, campaign_id)
    @campaign_id = campaign_id
    @description = description
    @title = subject
    mail(:to=> mail, :subject => subject)
  end  
end
