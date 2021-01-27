# frozen_string_literal: true

# name: forum user JWT token generator
# about: Custom plugin for generating JWT token for external forum user
# version: 0.0.1
# authors: zero-dev

after_initialize do
  class ::SingleSignOnRecord < ActiveRecord::Base
    after_create :generate_forum_user_jwt_token

    private

    def generate_forum_user_jwt_token
      if !user.forum_user_jwt_token && SiteSetting.forum_user_jwt_secret.present?
        user.update_column(:forum_user_jwt_token, JWT.encode({ user_id: external_id }, SiteSetting.forum_user_jwt_secret))
      end
    end
  end

  class ::UserSerializer < UserCardSerializer
    attributes :bio_raw,
               :bio_cooked,
               :can_edit,
               :can_edit_username,
               :can_edit_email,
               :can_edit_name,
               :uploaded_avatar_id,
               :has_title_badges,
               :pending_count,
               :profile_view_count,
               :second_factor_enabled,
               :second_factor_backup_enabled,
               :second_factor_remaining_backup_codes,
               :associated_accounts,
               :profile_background_upload_url,
               :can_upload_profile_header,
               :can_upload_user_card_background,
               :external_forum_id,
               :forum_user_jwt_token

    def external_forum_id
      object.single_sign_on_record.external_id if object.single_sign_on_record
    end
  end
end
