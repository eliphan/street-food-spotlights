class Post < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :title

  def slug
    self.title.downcase.gsub("", "-")
  end

  def self.find_by_slug(slug)
    self.all.find {|it| it.slug == slug}
  end
end
