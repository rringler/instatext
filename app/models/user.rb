class User < ActiveRecord::Base

  has_many :alerts, dependent: :destroy

  validates :username, presence: true,
  										 uniqueness: true

  validates :phone, presence: true,
                    uniqueness: true


  # Class methods
  def self.create_from_params(params)
    create! do |user|
      user.access_token = params['access_token']
      user.username     = params['username']
      user.phone        = params['phone']
    end
  end

  # Instance methods
  def notify(twilio_client)
    options = {
      from: '+14155992671',
      to: '+1' << phone,
      body: 'New post!'
    }
    twilio_client.account.sms.messages.create(options)
  end

  def create_alert_if_available(instagram_id, instagram_username)
    alert_details = { user_id: id,
                      instagram_id: instagram_id,
                      instagram_username: instagram_username }

    alerts << Alert.find_or_create(alert_details) if available_alerts?
  end

  def available_alerts?
    alerts.size < max_alerts
  end

  def set_max_alerts!(alerts)
    max_alerts = alerts
    save
  end

  def get_access_token(code)
    response = Instagram.get_access_token(code, redirect_uri: get_url(:auth_callback))
    response.access_token
  end

  def find_by_instagram_code(code)
    respose = get_access_token(code)
    find_by_access_token(response.access_token)
  end
end
