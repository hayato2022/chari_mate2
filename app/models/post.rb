class Post < ApplicationRecord
  has_one_attached :image
  # has_one_attached :video
  belongs_to :user
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  def save_tag(sent_tags)
    # タグが存在していれば、タグの名前を配列として取得
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 「今あるタグ」から「新たに送られてきたタグ」を引いて、「old_tags」に代入
    old_tags = current_tags - sent_tags
    # 「送信されてきたタグ」から「現在存在するタグ」を除いたタグをnew_tagsとする
    new_tags = sent_tags - current_tags
    # 古いタグを消す
    old_tags.each do |old|
      self.tags.delete Tag.find_by(name: old)
    end
    # 新しいタグを保存
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(name: new)
      self.tags << new_post_tag
    end
  end

  def get_image(width, height)
   unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
      image.variant(resize_to_limit: [width, height]).processed
  end

end
