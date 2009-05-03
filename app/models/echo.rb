class Echo < ActiveRecord::Base
  self.table_name = "echoes"
  serialize :auth_details
  validates_presence_of :username
  validates_presence_of :auth_details
  validates_uniqueness_of :username
  def to_param
    username
  end

  def relayed?(message_id)
    self.relayed_ids && self.relayed_ids.split(",").map(&:to_i).include?(message_id)
  end

  def relayed!(message_id)
    self.relayed_ids ||= ""
    self.relayed_ids = [self.relayed_ids, message_id.to_s].compact.join(",")
    save!
  end

  def fast_forward?
    if self.relayed_ids.nil?
      update_attribute(:relayed_ids, "")
      true
    end
  end
end
