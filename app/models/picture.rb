class Picture < ActiveRecord::Base

  has_attachment :content_type => :image,
                 :storage => :db_file,
                 :max_size => 2.megabytes,
                 :resize_to => '320x200>',
                 :thumbnails => { :thumb => '150x150>', :mini => '40x40>' }

  validates_as_attachment

  belongs_to :person

  attr_accessible :uploaded_data
  
end
