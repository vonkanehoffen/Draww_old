class Vote < ActiveRecord::Base
  
  # TODO: Here's a problem: A user creates an image. He automaticaly gets a vote (he'd do that anyway). Therefore casting power increases just by uplaoding stuff. Not good. Perhaps we need a validation saying you can't vote for your own post or something like that? Also, to stop gaming the system, wonder how hard it'd be to record the IP votes came from? Would be good data to have for the future....
  
  belongs_to :user
  belongs_to :post
  
  after_create :set_points
  validates_uniqueness_of :user_id, :scope => :post_id
  
  def heat
    self.points/ ((Date.today - created_at.to_date).to_i + 1)
  end

  private
    def set_points
      self.points ||= self.user.casting_power
      raise unless self.save!
    end

end
