class AddExperienceIdToCkeditorAssets < ActiveRecord::Migration
  def change
    if table_exists?(:ckeditor_assets)
    def change
      add_column :ckeditor_assets, :experience_id, :integer
      add_index  :ckeditor_assets, :experience_id
    end
  end
  end
end
