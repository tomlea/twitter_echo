class Echo < ActiveRecord::Base
  self.table_name = "echoes"
  serialize :auth_details
  validates_presence_of :username
  validates_presence_of :auth_details
  validates_uniqueness_of :username
  def to_param
    username
  end
end
