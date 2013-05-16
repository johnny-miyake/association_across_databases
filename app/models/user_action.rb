class UserAction < ActiveRecord::Base
  establish_connection :log_db
  attr_accessible :user_id, :action
  belongs_to :user
end
