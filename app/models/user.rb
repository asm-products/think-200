# == Schema Information
#
# Table name: users
#
#  admin                  :boolean          default(FALSE), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  created_at             :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  id                     :integer          not null, primary key
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  locked                 :boolean          default(FALSE), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0), not null
#  slug                   :string(255)
#  unconfirmed_email      :string(255)
#  updated_at             :datetime
#  username               :string(255)      default(""), not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

class User < ActiveRecord::Base
  # Use friendly_id on Users
  extend FriendlyId
  friendly_id :friendify, use: :slugged
  
  # necessary to override friendly_id reserved words
  def friendify
    if username.downcase == "admin"
      "user-#{username}"
    else
      "#{username}"
    end
  end
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
         
  has_many :projects, dependent: :destroy
  has_many :apps, through: :projects
  has_many :requirements, through: :apps
  has_many :expectations, through: :requirements

  # Pagination
  paginates_per 100
  
  # Validations
  # :username
  validates :username, uniqueness: { case_sensitive: false }
  validates_format_of :username, with: /\A[a-zA-Z0-9]*\z/, on: :create, message: "can only contain letters and digits"
  validates :username, length: { in: 4..10 }
  # :email
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  def self.paged(page_number)
    order(admin: :desc, username: :asc).page page_number
  end
  
  def self.search_and_order(search, page_number)
    if search
      where("username LIKE ?", "%#{search.downcase}%").order(
      admin: :desc, username: :asc
      ).page page_number
    else
      order(admin: :desc, username: :asc).page page_number
    end
  end
  
  def self.last_signups(count)
    order(created_at: :desc).limit(count).select("id","username","slug","created_at")
  end
  
  def self.last_signins(count)
    order(last_sign_in_at: 
    :desc).limit(count).select("id","username","slug","last_sign_in_at")
  end
  
  def self.users_count
    where("admin = ? AND locked = ?",false,false).count
  end
end
