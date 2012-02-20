class Post < ActiveRecord::Base
  
  attr_accessor :attachment64
  before_validation :save_attachment64
  before_save :default_values
  # paginates_per 10 < set in config/initializers/kaminari_config
 
  # Paperclip
  # All photos should be 3 to 2 aspect
  has_attached_file :photo,
    :styles => {
      :thumb=>    ["160x107>", :jpg],
      :small  =>  ["320x213>", :jpg],
      :medium =>  ["640x427>", :jpg],
      :large =>   ["1024x683>", :jpg] 
      }
      
  validates :title, 
    :length => { :minimum => 2, :maximum => 40, :message => "Sorry, title too long or too short" },
    :presence => {:message => "Title can't be blank" }
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 1.megabytes

  has_many :comments, :dependent => :destroy
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings
  attr_writer :tag_names
  after_save :assign_tags
  belongs_to :user

  has_many :votes
  
  has_many :relationships, :dependent => :destroy
  has_many :parents, :through => :relationships
  has_many :inverse_relationships, :class_name => "Relationship", :foreign_key => "relation_id"
  has_many :children, :through => :inverse_relationships, :source => :post
  
  private
  def save_attachment64
    if self.attachment64
      require Rails.root.join('lib', 'datafy.rb')
      tmp_uri = "tmp/"+friendly_name(self.title)+".jpg"
      puts "Friendly name = "+tmp_uri
      File.open(tmp_uri, "wb") { |f| f.write(Datafy::decode_data_uri(attachment64)[0]) }  
      self.photo = File.open(tmp_uri, "r")
    end
  end

  def friendly_name(str)
    s = Iconv.iconv('ascii//ignore//translit', 'utf-8', str).to_s
    s.downcase!
    s.gsub!(/'/, '')
    s.gsub!(/[^A-Za-z0-9]+/, ' ')
    s.strip!
    s.gsub!(/\ +/, '-')
    return s
  end
  
  # Ranking
  def default_values
    self.upvote = 1 unless self.upvote
    self.downvote = 0 unless self.downvote
    self.rank = 1 unless self.rank
  end
    
  # Tagging
  
  public
  
  def tag_names
    @tag_names || tags.map(&:name).join(' ')
  end
  
  # Ranking System
  
  def votes_count
    self.votes.count
  end
  
  def votes_score
    votes.inject(0){|s,v| s += v.points || 0} 
  end

  def hotness
    votes.inject(0){|s,v| s += v.heat || 0} 
  end

  private

  def assign_tags
    if @tag_names
      self.tags = @tag_names.split(/\s+/).map do |name|
        Tag.find_or_create_by_name(name)
      end
    end
  end

end

