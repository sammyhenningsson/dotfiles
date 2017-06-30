require 'models/user'
require 'policies/user'

module Serializers
  class User
    extend HALDecorator
    extend UriHelper

    model ::User
    policy ::UserPolicy

    # The users username.
    attribute :username

    # The users email address.
    attribute :email

    # Link to this resource.  
    # Method: GET  
    # Example:  
    #```
    # curl -H "Accept: "application/vnd.api+json" \
    #      -H "Authorization: "abcdef \
    #      /api/users/5
    #```
    link :self do
      user_uri(resource)
    end

    # Link to update this resource.  
    # Method: PUT  
    # Example:  
    #```
    # curl -H "Accept: "application/vnd.api+json" \
    #      -H "Authorization: "abcdef \
    #      -X PUT -d '{"user": {"name": "Bengt Bengtsson"}}'
    #      /api/users/5
    #```
    link :edit do
      user_uri(resource)
    end

    # Link to get a form for updating this resource.  
    # Method: GET  
    # Example:  
    #```
    # curl -H "Accept: "application/vnd.api+json" \
    #      -H "Authorization: "abcdef \
    #      /api/users/5/edit-form
    #```
    link :'edit-form' do
      edit_user_uri(resource)
    end

    # Link to remove this resource.  
    # Method: DELETE  
    # Example:  
    #```
    # curl -H "Accept: "application/vnd.api+json" \
    #      -H "Authorization: "abcdef \
    #      /api/users/5/edit-form
    #```
    link :delete do
      user_uri(resource)
    end

    collection of: 'users' do
      link :self, UriHelper.users_uri
    end
  end
end
