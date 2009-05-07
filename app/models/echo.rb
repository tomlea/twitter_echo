require 'drb'

class Echo < ActiveRecord::Base
  self.table_name = "echoes"
  serialize :auth_details
  validates_presence_of :username
  validates_presence_of :auth_details
  validates_uniqueness_of :username

  after_create :add_to_background_worker
  before_destroy :remove_from_background_worker

  def to_param
    username
  end

  def relayed?(message_id)
    self.relayed_ids && self.relayed_ids.split(",").map(&:to_i).include?(message_id)
  end

  def relayed!(message_id)
    self.relayed_ids ||= ""
    self.relayed_ids = [message_id.to_s, *self.relayed_ids.to_s.split(",")].uniq.compact.join(",")
    save!
  end

  def fast_forward?
    if self.relayed_ids.nil?
      update_attribute(:relayed_ids, "")
      true
    end
  end

private

  def add_to_background_worker
    drb_server.add(id) if drb_server
  rescue => ex
    logger.error "/Probably/ could not connect to drb_server."
    logger.error "#{ex.class} : #{ex.message}"
  end

  def remove_from_background_worker
    drb_server.del(id) if drb_server
  rescue => ex
    logger.error "/Probably/ could not connect to drb_server."
    logger.error "#{ex.class} : #{ex.message}"
  end

  def drb_server
    return @drb_server ||= DRb::DRbObject.new(nil, "druby://localhost:59557")
  end
end
