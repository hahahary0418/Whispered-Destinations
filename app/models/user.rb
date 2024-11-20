class User < ApplicationRecord
  # Deviseモジュール
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  # バリデーション
  validates :name, presence: true
  validates :email, presence: true
  validates :introduction, length: { maximum: 50 }, allow_blank: true
  
  # アソシエーション
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :post
  has_many :group_users, dependent: :destroy
  has_many :permits, dependent: :destroy
  has_many :groups, through: :group_users
  has_many :messages, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_one_attached :profile_image
  
  # 画像処理
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
  
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      # user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
      # 例えば name を入力必須としているならば， user.name = "ゲスト" なども必要
    end
  end
  
  def guest?
    email == 'guest@example.com'
  end
  
  # 管理者判定
  def admin?
    self.role == 'admin'
  end
  
  # 退会処理
  def soft_delete
    update(is_deleted: true)
  end
  
  def user_status
    if is_deleted == true
      "退会"
    else
      "有効"
    end
  end
  
  # 認証有効性チェック
  def active_for_authentication?
    super && !is_deleted?
  end

  # 退会済みユーザーへのメッセージ設定
  def inactive_message
    is_deleted? ? :deleted_account : super
  end
  
  # 退会済み判定メソッド
  def is_deleted?
    is_deleted
  end
  
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end
  
  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end
  
  def following?(user)
    followings.include?(user)
  end
  
  # 検索メソッド
  def self.looks(search, word)
    case search
    when "perfect_match"
      where("name LIKE ?", "#{word}")
    when "forward_match"
      where("name LIKE ?", "#{word}%")
    when "backward_match"
      where("name LIKE ?", "%#{word}")
    when "partial_match"
      where("name LIKE ?", "%#{word}%")
    else
      all
    end
  end
end