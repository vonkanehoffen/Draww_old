class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  
  after_create :set_points
  validates_uniqueness_of :user_id, :scope => :post_id
  
  def heat
    self.points/ (Date.today - created_at.to_date).to_i
  end

  private
    def set_points
      self.points ||= self.user.casting_power
      raise unless self.save!
    end

end
