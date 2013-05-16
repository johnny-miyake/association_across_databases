class User < ActiveRecord::Base
  attr_accessible :name
  has_many :user_actions
end
