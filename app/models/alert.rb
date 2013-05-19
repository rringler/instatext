class Alert < ActiveRecord::Base
	
	#attr_accessible :user_id, :instagram_id, :instagram_username

	belongs_to :user, foreign_key: :user_id

	validates :user_id, presence: true
	validates :instagram_id, presence: true
	validates :instagram_username, presence: true

	def self.find_or_create(args)
		where(args).first || create(args)
	end

	def self.alert_exists?(args)
		!where(args).empty?
	end
end