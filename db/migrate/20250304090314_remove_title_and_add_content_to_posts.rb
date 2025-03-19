class RemoveTitleAndAddContentToPosts < ActiveRecord::Migration[7.2]
  def change
    remove_column :posts, :title    # titleカラムを削除
    add_column :posts, :content, :text    # contentカラムを追加
  end
end
