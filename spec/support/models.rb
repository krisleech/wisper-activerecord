class Meeting < ActiveRecord::Base
  validates :title, presence: true # database default to non-blank value
end
