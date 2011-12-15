class Post < ActiveRecord::Base
  
  attr_accessor :attachment64
  before_validation :save_attachment64
  before_save :default_values
  paginates_per 10
  # TODO: needs to validate filesize
  
  # Paperclip
  # All photos should be 3 to 2 aspect
  has_attached_file :photo,
    :styles => {
      :thumb=>    ["160x107>", :jpg],
      :small  =>  ["320x213>", :jpg],
      :medium =>  ["640x427>", :jpg],
      :large =>   ["1024x683>", :jpg] 
      }
      
  validates_presence_of :title, :message => "No Title!"
  validates_attachment_presence :photo
  # validates :title, :presence => true, :length => { :minimum => 2 }
  has_many :comments, :dependent => :destroy
  has_many :tags
  belongs_to :user    
      
  accepts_nested_attributes_for :tags, :allow_destroy => :true,
      :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
      
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

end

