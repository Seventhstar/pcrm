class AddSecretToAttachments < ActiveRecord::Migration[5.1]
  def change
    add_column :attachments, :secret, :boolean
  end
end
