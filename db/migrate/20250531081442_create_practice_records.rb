class CreatePracticeRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :practice_records do |t|
      t.string :driving_range_name
      t.integer :practice_hour
      t.integer :ball_count
      t.text :effort_focus
      t.string :video_reference

      t.timestamps
    end
  end
end
