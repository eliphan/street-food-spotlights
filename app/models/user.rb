class User < ActiveRecord::Base
  has_many :posts
  has_secure_password
  validates_presence_of :username
  validates_uniqueness_of :username
  validates :username, format: { with: /\A[a-zA-Z0-9]+\Z/ }
  
  def slug
    self.username.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    self.all.find {|it| it.slug == slug}
  end


end
