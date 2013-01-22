class Article < ActiveRecord::Base

  belongs_to :box

  def to_param
    slug_dirname = dirname.sub(/\//, '')

    if slug_dirname == ''
      slug
    else
      File.join(slug_dirname, slug)
    end
  end

  def slug_with_id
    "#{id}-#{slug}"
  end

end
