require 'cgi'
require 'securerandom'
require 'uri'
require 'base64'
require 'json'
require 'openssl'

module LookerEmbedClient
  def self.created_signed_embed_url(options)
    # looker options
    secret = options[:secret]
    host = options[:host]

    # user options
    json_external_user_id   = options[:external_user_id].to_json
    json_first_name         = options[:first_name].to_json
    json_last_name          = options[:last_name].to_json
    json_permissions        = options[:permissions].to_json
    json_models             = options[:models].to_json
    json_access_filters     = options[:access_filters].to_json

    # url/session specific options
    embed_path              = '/login/embed/' + CGI.escape(options[:embed_url])
    json_session_length     = options[:session_length].to_json
    json_force_logout_login = options[:force_logout_login].to_json

    # computed options
    json_time               = Time.now.to_i.to_json
    json_nonce              = SecureRandom.hex(16).to_json

    # compute signature
    string_to_sign  = ""
    string_to_sign += host                  + "\n"
    string_to_sign += embed_path            + "\n"
    string_to_sign += json_nonce            + "\n"
    string_to_sign += json_time             + "\n"
    string_to_sign += json_session_length   + "\n"
    string_to_sign += json_external_user_id + "\n"
    string_to_sign += json_permissions      + "\n"
    string_to_sign += json_models           + "\n"
    string_to_sign += json_access_filters

    signature = Base64.encode64(
                   OpenSSL::HMAC.digest(
                      OpenSSL::Digest::Digest.new('sha1'),
                      secret,
                      string_to_sign.force_encoding("utf-8"))).strip

    # construct query string
    query_params = {
      nonce:               json_nonce,
      time:                json_time,
      session_length:      json_session_length,
      external_user_id:    json_external_user_id,
      permissions:         json_permissions,
      models:              json_models,
      access_filters:      json_access_filters,
      first_name:          json_first_name,
      last_name:           json_last_name,
      force_logout_login:  json_force_logout_login,
      signature:           signature
    }
    query_string = query_params.to_a.map { |key, val| "#{key}=#{CGI.escape(val)}" }.join('&')

    "#{host}#{embed_path}?#{query_string}"
  end
end