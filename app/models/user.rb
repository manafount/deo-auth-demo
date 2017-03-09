class User
  include Mongoid::Document
  field :provider, type: String
  field :uid, type: String
  field :name, type: String
  field :location, type: String
  field :image_url, type: String
  field :url, type: String

  class << self
    def from_omniauth(auth_hash)
      user = find_or_create_by(uid: auth_hash['uid'], provider: auth_hash['provider'])
      user.name = auth_hash['info']['name']
      user.location = get_social_location_for user.provider, auth_hash['info']['location']
      user.image_url = auth_hash['info']['image']
      user.url = get_social_url_for user.provider, auth_hash['info']['urls']
      user.save!
      user
    end

    private

    def get_social_location_for(provider, location_hash)
      case provider
        when 'linkedin'
          location_hash['name']
        else
          location_hash
      end
    end

    def get_social_url_for(provider, urls_hash)
      case provider
        when 'linkedin'
          urls_hash['public_profile']
        else
          urls_hash[provider.capitalize]
      end
    end
  end
end
