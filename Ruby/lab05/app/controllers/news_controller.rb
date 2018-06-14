class NewsController < ApplicationController
  def news
	  @article_list = Article.all
  end

  def branches
	  @branch = Branch.find_by(id: params["identifier"])
  end

  def authors
	  @author = Author.find_by(id: params["identifier"])
  end

  def addArticle
	@branches = Branch.all
	@authors = Author.all
  end

  def addBranch
	
  end

  def addAuthor

  end
end
