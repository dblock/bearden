class CreateFetchedWebsites < ActiveRecord::Migration[5.0]
  def change
    create_table :fetched_websites do |t|
      t.string :redirects_to
      t.string :status
      t.string :url
      t.timestamps
    end
  end
end
