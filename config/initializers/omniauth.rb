Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '313338422205865', '145bde3f675e98ff5a0b158b554077a3'
end