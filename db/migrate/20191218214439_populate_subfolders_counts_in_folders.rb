class PopulateSubfoldersCountsInFolders < ActiveRecord::Migration[5.2]
  def up
    Folder.all.each do |f|
      count = f.children.count
      f.update_attribute :subfolders_counts, count
      puts "set #{f.name}(#{f.id}) => #{count}"
    end
  end

  def down
    Folder.update_all(subfolders_counts: 0)
  end
end
