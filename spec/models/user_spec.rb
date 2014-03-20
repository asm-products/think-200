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

require 'spec_helper'

describe User do
  let(:valid_user) {User.new email: 'foo@bar.com', password: 'sekret', username: 'iggy'}
  let(:user)       {valid_user}

  describe '#valid?' do
    it 'with valid attributes' do
      expect(valid_user).to be_valid
    end

    it 'when username <= 20' do
      valid_user.username = 'x'*20
      expect(valid_user).to be_valid
    end

    it 'when username >= 4' do
      valid_user.username = 'x'*4
      expect(valid_user).to be_valid
    end
  end

  describe '#invalid?' do
    it 'when username > 20' do
      user.username = 'x'*21
      expect(user).to be_invalid
    end

    it 'when username < 4' do
      user.username = 'x'*3
      expect(user).to be_invalid
    end

    it 'when username includes a space' do
      user.username = 'Inigo Montoya'
      expect(user).to be_invalid
    end
  end
end
