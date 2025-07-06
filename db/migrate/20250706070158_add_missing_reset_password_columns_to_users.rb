class AddMissingResetPasswordColumnsToUsers < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:users, :reset_password_token)
      add_column :users, :reset_password_token, :string
      add_index  :users, :reset_password_token
    end

    unless column_exists?(:users, :reset_password_token_expires_at)
      add_column :users, :reset_password_token_expires_at, :datetime
    end

    unless column_exists?(:users, :reset_password_email_sent_at)
      add_column :users, :reset_password_email_sent_at, :datetime
    end

    unless column_exists?(:users, :access_count_to_reset_password_page)
      add_column :users, :access_count_to_reset_password_page, :integer, default: 0, null: false
    end
  end
end
