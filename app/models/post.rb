class Post < ActiveRecord::Base
  
  attr_accessor :attachment64
  before_validation :save_attachment64
  
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
      require Rails.root.join('lib', 'datafy.rb')
      File.open("tmp/reply.jpg", "wb") { |f| f.write(Datafy::decode_data_uri(attachment64)[0]) }  
      self.photo = File.open("tmp/reply.jpg", "r")
    end

end

