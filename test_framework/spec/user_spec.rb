require_relative '../runner'
require 'sequel'

Sequel.connect 'postgres://localhost/test_framework'

class User < Sequel.Model(:users)
  def change_email(email)
    update(email: email)
  end
end

describe User do
  let(:user) do
    User.create(
      email: 'alice@example.com', last_login: Time.new(2015, 10, 21, 10, 22)
    )
  end

  it 'has an email address' do
    user.email.should == 'alice@example.com'
  end

  it 'has a last login time' do
    user.last_login.should == Time.new(2015, 10, 21, 10, 22)
  end

  it 'has some attributes' do
    user.to_hash.should ==
      {
        id: user.id,
        email: 'alice@example.com',
        last_login: Time.new(2015, 10, 21, 10, 22)
      }
  end

  it 'can change emails' do
    user.change_email('niki@example.com')
    user.email.should == 'niki@example.com'
  end
end
