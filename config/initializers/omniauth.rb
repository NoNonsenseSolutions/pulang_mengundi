OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'],
   scope: 'public_profile,email', info_fields: 'email,id,name,link,picture', :image_size => { width: 200, height: 200},
   secure_image_url: true

end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET'], :image_size => 'original',
  secure_image_url: true
end