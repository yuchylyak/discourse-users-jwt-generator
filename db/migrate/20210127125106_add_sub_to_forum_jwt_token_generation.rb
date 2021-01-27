class AddSubToForumJwtTokenGeneration < ActiveRecord::Migration[6.0]
  def up
    if SiteSetting.forum_user_jwt_secret.present?
      User.find_each do |user|
        if user.single_sign_on_record
          user.update_column(
            :forum_user_jwt_token,
            JWT.encode({ sub: '1234567890', user_id: user.single_sign_on_record.external_id }, SiteSetting.forum_user_jwt_secret)
          )
        end
      end
    end
  end

  def down
    # nothing to revert
  end
end
