class ChangeDefaultIsDeletedInEndUsers < ActiveRecord::Migration[6.1]
    def up
      change_column_default :end_users, :is_deleted, false
    end

    def down
      change_column_default :end_users, :is_deleted, nil
    end
end
