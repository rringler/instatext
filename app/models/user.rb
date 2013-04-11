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

  def create_alert_if_available(id, username)
    Alert.create_if_unique(user_id: self.id,
                           instagram_id: id,
                           instagram_username: username) if available_alerts?
  end

  def available_alerts?
    alerts.size < max_alerts
  end

  def set_max_alerts!(alerts)
    max_alerts = alerts
    save
  end
end
