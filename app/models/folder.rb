# frozen_string_literal: true

# == Schema Information
#
# Table name: folders
#
#  id                :integer          not null, primary key
#  name              :string
#  created_at        :datetime
#  updated_at        :datetime
#  ancestry          :string
#  bucket_id         :integer
#  peepy             :boolean          default(FALSE), not null
#  nsfw              :boolean          default(FALSE), not null
#  cloud_files_count :integer          default(0), not null
#  subfolders_count  :integer          default(0), not null
#
# Description: Folders are only metadata to preserve the same tree layout as found on the user's drive
class Folder < ApplicationRecord
  include Reactable
  has_ancestry

  belongs_to :bucket
  has_many :cloud_files, -> { order('release_pos' )}

  validates_uniqueness_of :name, scope: :ancestry

  # scope :clean, where(:peepy => false)
  scope(:alpha, -> { order('name') })
  scope(:clean, -> { where(peepy: false) })
  scope(:peepy, -> { where(peepy: true) })

  scope(:has_files, -> { where('cloud_files_count > 0') })
  scope(:has_subfolders, -> { where('subfolders_count > 0') })
  scope(:has_content, -> { where('subfolders_count > 0 OR cloud_files_count > 0') })
  # default_scope { where(:peepy => false) }

end
