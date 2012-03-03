
class Regexp

  IP_ADDRESS = /(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})/.freeze
  EMAIL_ADDRESS = /^([a-z0-9]+[a-z0-9\.\-\_\+]*)@([a-z0-9\.\-]+\.[a-z]{2,})$/
  DOMAIN = /^([a-z0-9\.\-]+\.[a-z]{2,})$/

end
