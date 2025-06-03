class CreateScoreRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :score_records do |t|
      t.string :course_name
      t.integer :score

      t.timestamps
    end
  end
end
