require 'spec_helper'

describe User do
  let(:valid_user) {User.new email: 'foo@bar.com', password: 'sekret', username: 'iggy'}
  let(:user)       {valid_user}

  describe '#valid?' do
    it 'with valid attributes' do
      expect(valid_user).to be_valid
    end

    it 'when username <= 10' do
      valid_user.username = 'x'*10
      expect(valid_user).to be_valid
    end

    it 'when username >= 4' do
      valid_user.username = 'x'*4
      expect(valid_user).to be_valid
    end
  end

  describe '#invalid?' do
    it 'when username > 10' do
      user.username = 'x'*11
      expect(user).to be_invalid
    end

    it 'when username < 4' do
      user.username = 'x'*3
      expect(user).to be_invalid
    end
  end
end