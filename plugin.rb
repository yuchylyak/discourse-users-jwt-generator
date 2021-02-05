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
        user.update_column(:forum_user_jwt_token, JWT.encode({ sub: '1234567890', user_id: external_id.to_i }, SiteSetting.forum_user_jwt_secret))
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
               :external_forum_id

    def external_forum_id
      object.single_sign_on_record.external_id if object.single_sign_on_record
    end
  end

  class ::CurrentUserSerializer < BasicUserSerializer
    attributes :name,
               :unread_notifications,
               :unread_private_messages,
               :unread_high_priority_notifications,
               :read_first_notification?,
               :admin?,
               :notification_channel_position,
               :moderator?,
               :staff?,
               :title,
               :any_posts,
               :enable_quoting,
               :enable_defer,
               :external_links_in_new_tab,
               :dynamic_favicon,
               :trust_level,
               :can_send_private_email_messages,
               :can_edit,
               :can_invite_to_forum,
               :no_password,
               :can_delete_account,
               :should_be_redirected_to_top,
               :redirected_to_top,
               :custom_fields,
               :muted_category_ids,
               :muted_tag_ids,
               :dismissed_banner_key,
               :is_anonymous,
               :reviewable_count,
               :read_faq,
               :automatically_unpin_topics,
               :mailing_list_mode,
               :previous_visit_at,
               :seen_notification_id,
               :primary_group_id,
               :can_create_topic,
               :can_create_group,
               :link_posting_access,
               :external_id,
               :top_category_ids,
               :hide_profile_and_presence,
               :groups,
               :second_factor_enabled,
               :ignored_users,
               :title_count_mode,
               :timezone,
               :featured_topic,
               :skip_new_user_tips,
               :do_not_disturb_until,
               :external_forum_id,
               :forum_user_jwt_token

    def external_forum_id
      object.single_sign_on_record.external_id if object.single_sign_on_record
    end
  end
end
