class FieldTest < ActiveRecord::Base
  has_many :nested_field_tests, dependent: :destroy, inverse_of: :field_test
  accepts_nested_attributes_for :nested_field_tests, allow_destroy: true

  has_one :comment, as: :commentable
  accepts_nested_attributes_for :comment, allow_destroy: true

  has_attached_file :paperclip_asset, styles: {thumb: '100x100>'}
  attr_accessor :delete_paperclip_asset
  before_validation { self.paperclip_asset = nil if delete_paperclip_asset == '1' }

  dragonfly_accessor :dragonfly_asset
  mount_uploader :carrierwave_asset, CarrierwaveUploader

  attachment :refile_asset if defined?(Refile)

  has_one_attached :active_storage_asset if defined?(ActiveStorage)
  attr_accessor :remove_active_storage_asset
  after_save { active_storage_asset.purge if remove_active_storage_asset == '1' }

  if ::Rails.version >= '4.1' # enum support was added in Rails 4.1
    enum string_enum_field: {S: 's', M: 'm', L: 'l'}
    enum integer_enum_field: [:small, :medium, :large]
  end
end
