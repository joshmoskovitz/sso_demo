require 'auth'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :timeoutable, :timeout_in => 20.minutes
  def embed_url

    url_data = {
                 host:               'demo.looker.com',
                 secret:             'f5bf62d1d44c5acaef19184055896e4b4749fedcefcf1acb838110b39ac19c30',
                 external_user_id:   self.id,
                 first_name:         self.first_name,
                 last_name:          self.last_name,
                 permissions:        ['see_user_dashboards', 'see_lookml_dashboards', 'access_data', 'see_looks'],
                 models:             ['thelook_embed'],
                 access_filters:     {:thelook_embed => {:'brand.name' => self.company}},
                 session_length:     20.minutes,
                 embed_url:          "/embed/sso/dashboards/thelook_embed/embedded_supplier_portal",
                 force_logout_login: true
               }

    url = LookerEmbedClient::created_signed_embed_url(url_data)

    "https://#{url}"

  end

end
