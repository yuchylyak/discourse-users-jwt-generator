# frozen_string_literal: true

class AddForumUserJwtTokenToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :forum_user_jwt_token, :string

    if SiteSetting.forum_user_jwt_secret.present?
      User.find_each do |user|
        if user.single_sign_on_record
          user.update_column(
            :forum_user_jwt_token,
            JWT.encode(user.single_sign_on_record.external_id, SiteSetting.forum_user_jwt_secret)
          )
        end
      end
    end
  end

  def down
    remove_column :users, :forum_user_jwt_token
  end
end
