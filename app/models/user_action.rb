class UserAction < ActiveRecord::Base
  establish_connection :log_db_development
  attr_accessible :user_id, :action
  belongs_to :user
end
