class Alert < ActiveRecord::Base
	
	attr_accessible :user_id, :instagram_id, :instagram_username

	belongs_to :user, foreign_key: :user_id

	validates :user_id, presence: true
	validates :instagram_id, presence: true
	validates :instagram_username, presence: true

	def self.create_if_new(args)
		create!(args) unless find_by_instagram_id(args[:instagram_id])
	end

	def self.alert_exists?(args)
		find_by_user_id_and_instagram_id(args[:user_id], args[:instagram_id])
	end

	def notify_user
		# TODO.  Add twilio code.
	end
end
