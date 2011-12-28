Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'qwQ5Hgx64nXLYauBiYrOA', 'f6kKCo81jM7YWVLJdaRzpcwHLUjIkR04PNGaYARVbA'
  provider :facebook, '295927413778725', '38856265151ab5faac403d5b12da7224'
end