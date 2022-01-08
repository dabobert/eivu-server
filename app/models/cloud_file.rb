# frozen_string_literal: true

# == Schema Information
#
# Table name: cloud_files
#
#  id             :integer          not null, primary key
#  name           :string
#  asset          :string
#  md5            :string
#  content_type   :string
#  filesize       :bigint           default(0)
#  description    :text
#  rating         :float
#  nsfw           :boolean          default(FALSE)
#  peepy          :boolean          default(FALSE)
#  created_at     :datetime
#  updated_at     :datetime
#  folder_id      :integer
#  info_url       :string
#  bucket_id      :integer
#  duration       :integer          default(0)
#  settings       :integer          default(0), not null
#  ext_id         :string
#  data_source_id :integer
#  release_id     :integer
#  year           :integer
#  release_pos    :integer
#  user_id        :integer
#  num_plays      :integer          default(0), not null
#
class CloudFile < ApplicationRecord
  include Reactable
  include AASM

  belongs_to :folder, counter_cache: true
  belongs_to :bucket#, inverse_of: :cloud_file
  belongs_to :release, counter_cache: true
  has_one :user, through: :bucket
  has_many :artist_cloud_files, dependent: :destroy
  has_many :artists, through: :artist_cloud_files
  has_many :metataggings, dependent: :destroy
  has_many :metadata, through: :metataggings, dependent: :destroy
  has_many :taggings, class_name: 'CloudFileTagging', dependent: :destroy
  has_many :tags, through: :taggings

  scope(:alpha, -> { order('name') })
  scope(:peepy, -> { where(peepy: true) })

  accepts_nested_attributes_for :metataggings

  validates_uniqueness_of :md5, scope: :bucket_id
  validates_presence_of :bucket_id
  validates_presence_of :md5


  # ?????????????
  attr_accessor :relative_path, :path_to_file

  aasm :state do # add locking
    state :empty, initial: true
    state :reserved
    state :transfered, before_enter: :assign_xfer_attributes
    state :completed, before_enter: :complete_metadata_assigment

    event :reserve do
      transitions from: :empty, to: :reserved
    end

    event :transfer do
      transitions from: :reserved, to: :transfered
    end

    event :complete do
      transitions from: :transfered, to: :completed
    end
  end

  # assign parameters to object
  def assign_xfer_attributes(params = {})
    assign_attributes(params)
  end

  def complete_metadata_assigment(params = {})
    folder = Folder.create_from_path(
              fullpath:  params[:folder][:fullpath],
              bucket_id: params[:folder][:bucket_id],
              peepy:     params[:folder][:peepy],
              nsfw:      params[:folder][:nsfw]
            )
    update! params[:cloud_file_attributes].merge(folder_id: folder.id)
  end

  def visit
    system "open #{self.url}"
  end

  class << self
    def online?(uri)
      url = URI.parse(uri)
      req = Net::HTTP.new(url.host, url.port)
      req.request_head(url.path).code == '200'
    end

    def exists?(md5:, bucket:, folder:)
      CloudFile.where(md5: md5, bucket_id: bucket.id, folder_id: folder.try(:id)).first.try(:id)
    end

    def sanitize(name)
      name = name.tr('\\', '/') # work-around for IE
      name = File.basename(name)
      name = name.gsub(/[^a-zA-Z0-9\.\-\+_]/, '_')
      name = "_#{name}" if name =~ /\A\.+\z/
      name = 'unnamed' if name.size.zero?
      name.mb_chars.to_s
    end
  end

  def smart_name
    self.name || self.asset
  end

  def url
    raise "Region Not Defined for bucket: #{self.bucket.name}" if self.bucket.region_id.blank?

    @url ||= "http://#{self.bucket.name}.#{self.bucket.region.endpoint}/#{media_type}/#{md5.scan(/.{2}|.+/).join("/")}/#{self.asset}"
  end

  def filename
    self.asset
  end

  def path
    @path ||= "#{self.md5.scan(/.{2}|.+/).join("/")}/#{self.filename}"
  end

  def delete_remote
    user.s3_client.delete_object(
      # required
      bucket: bucket.name,
      # required
      key: path
    )
  end

  def media_type
    type = content_type.to_s.split('/')&.first
    type = "peepshow (#{type})" if peepy?
    type
  end

  def tag_list=(tag_array)
    tag_array.each do |value|
      tag = Tag.find_or_create_by! value: value, user_id: self.user.id
      self.cloud_file_taggings.find_or_initialize_by! tag_id: tag.id
    end

    binding.pry
  end

  def metadata_list=(info)
    binding.pry
  end


  ############################################################################
  private
  ############################################################################

  #relative path is used to construct the folder tree
  def parse_relative_path
    if self.relative_path.blank?
      self.folder_id = nil
    else
      @manual_ancestry= []
      #convert the file path into an array
      folder_array = self.relative_path.split("/").reject { |x| x.empty? }
      #remove the last element because it will always be the last element
      folder_array.pop
      folder_array.each do |sub_dir|
        if @manual_ancestry.present?
          ancestry_str = @manual_ancestry.join("/")
        else
          ancestry_str = nil
        end
        folder = Folder.find_or_create_by! ancestry: ancestry_str, bucket_id: self.bucket.id, name:sub_dir
        @manual_ancestry << folder.id
      end
      self.folder_id = @manual_ancestry.last
    end
  end

  def prune_release
    # release.destroy if self.release.cloud_files.blank?
  end
end
