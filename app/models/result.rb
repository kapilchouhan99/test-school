class Result < ApplicationRecord
	validates :subject, :marks,  presence: true
end
