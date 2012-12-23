require 'integration/spec_helper'

class Blog; end
module PostRepository; end

class MyProcess
  attr_reader :blog, :posts
  def initialize(blog, posts)
    @blog = blog
    @posts = posts
  end
end


describe 'Injection' do
  it 'can inject the dependencies into arbitrary methods' do
    Untangle.register :blog, Blog
    Untangle.register :posts, PostRepository

    process = Untangle.inject(MyProcess.method(:new))
    process.blog.should == Blog
    process.posts.should == PostRepository
  end
end
