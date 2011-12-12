class Post < ActiveRecord::Base
  
  require Rails.root.join('lib', 'datafy.rb')
  attr_accessor :attachment64
  before_validation :save_attachment64
  
  # Paperclip
  has_attached_file :photo,
    :styles => {
      :thumb=> "100x100#",
      :small  => "150x150>",
      :medium => "300x300>",
      :large =>   "400x400>" }
      
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
      File.open("tmp/reply.png", "wb") { |f| f.write(Datafy::decode_data_uri(attachment64)[0]) }  
      self.photo = File.open("tmp/reply.png", "r")
    end

end

