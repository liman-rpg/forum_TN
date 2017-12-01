module OmniauthMacros
  def mock_auth_hash(provider, email = 'mock@auth.com')
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
      provider: provider.to_s,
      uid: '12345',
      info: {
        email: email,
        name: 'mockuser'
      }
    })
  end

  def mock_auth_invalid_hash(provider)
    OmniAuth.config.mock_auth[provider] = :invalid_credentials
  end
end
