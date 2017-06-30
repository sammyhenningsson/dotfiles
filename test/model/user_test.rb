require 'test_helper'

module Model
  class UserTest < TestCase
    def setup
      @user = User.create(
        username: 'test_user',
        password: 'hidden',
        email: 'test@user.com',
      )
    end

    def test_create
      assert @user
      assert_equal @user.username, 'test_user'
      assert_equal @user.email, 'test@user.com'
      created = @user.created_at
      assert (created..(created + 30)).include? Time.now
    end

    def test_update_user
      digest = @user.password_digest
      @user.update(
        username: 'test_User',
        email: 'test@User.com',
        password: 'hidden2'
      )
      assert @user.created_at < @user.updated_at
      assert_equal 'test_User', @user.username
      assert_equal 'test@User.com', @user.email
      refute_equal digest, @user.password_digest
    end

    def test_delete_user
      @user.destroy
      assert_nil User.where(username: @user.username).first
    end
  end
end

