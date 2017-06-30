require 'test_helper'

module Integration
  class UserTest < TestCase

    def setup
      @user = User.create(
        username: 'test_user',
        password: 'hemligt',
        email: 'test@user.com'
      )
      User.create(
        username: 'foo',
        password: 'bar',
        email: 'foo@bar.com'
      )
    end

    def test_show_user
      get UriHelper.user_uri(@user)
      assert_status 200
      assert_attribute :username, 'test_user'
      assert_attribute :email, 'test@user.com'
      assert_link :self, UriHelper.user_uri(@user)
    end

    def test_list_users
      get UriHelper.users_uri
      assert_status 200
      assert_match UriHelper.users_uri, links[:self][:href]
      embedded :'users' do
        users = payload
        assert_equal 2, users.size
        assert_equal(
          ['test_user', 'foo'].sort,
          users.map { |u| u[:username] }.sort
        )
      end
    end

    def test_create_user
      get UriHelper.root_uri
      embedded :'create-user' do
        assert_link :self, UriHelper.new_user_uri
        assert_attribute :href, UriHelper.users_uri
        assert_attribute :method, "POST"
        assert_attribute :name, "create-user"
        assert_attribute :title, "Create User"
        assert_attribute :type, "application/json"
        fields = attribute[:fields]
        assert_equal 3, fields.size
      end

      data = {
        username: 'new_user',
        email: 'new@user.com',
        password: 'hemligt'
      }
      header 'Content-Type', 'application/json'
      post UriHelper.users_uri, JSON.generate(data)
      assert_status 201
    end

    def test_update_user
      login('test@user.com', 'hemligt')
      get UriHelper.user_uri(@user)
      assert_has_links :edit, :'edit-form'
      uri = links[:edit]

      get links[:'edit-form'][:href]
      assert_link :self, UriHelper.edit_user_uri(@user)
      assert_attribute :href, UriHelper.user_uri(@user)
      assert_attribute :method, "PUT"
      assert_attribute :name, "update-user"
      assert_attribute :title, "Update User"
      assert_attribute :type, "application/json"
      fields = attribute[:fields]
      assert_equal 3, fields.size

      data = {email: 'updated@user.com'}
      put attribute[:href], JSON.generate(data)
      assert_status 200
      assert_attribute :username, 'test_user'
      assert_attribute :email, 'updated@user.com'
      assert_link :self, UriHelper.user_uri(@user)

      get links[:self][:href]
      assert_status 200
      assert_attribute :username, 'test_user'
      assert_attribute :email, 'updated@user.com'
    end

    def test_delete_user
      login('test@user.com', 'hemligt')
      get UriHelper.user_uri(@user)
      uri = links[:self]
      assert_has_link :delete

      follow_rel(:delete, method: :delete)
      assert_status 204

      get uri[:href]
      assert_status 404
    end
  end
end

