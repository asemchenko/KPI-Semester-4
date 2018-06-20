class Article < ActiveRecord::Base
	belongs_to :author
	belongs_to :branch
end
