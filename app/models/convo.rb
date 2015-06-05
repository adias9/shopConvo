class Convo < ActiveRecord::Base

	validates :url, presence: true
end
