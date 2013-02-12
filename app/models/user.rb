class User < ActiveRecord::Base
  
  attr_accessible :access_token, :username, :phone

  has_many :alerts, dependent: :destroy

  validates :username, presence: true,
  										 uniqueness: true

  def self.from_params(params)
  	where(params.slice("username")).first
  end

  def self.create_from_params(params)
  	create! do |user|
  		user.access_token = params["access_token"]
  		user.username			= params["username"]
  		user.phone				= params["phone"]
  	end
  end

  def notify!(twilio_client)
    options = {
      from: '+14155992671',
      to: '+1' << phone,
      body: 'New post!'
    }
    twilio_client.account.sms.messages.create(options)
  end

  def available_alerts?
    self.alerts.size < max_alerts
  end

  def set_max_alerts(alerts)
    max_alerts = alerts
    save
  end
end
