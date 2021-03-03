# frozen_string_literal: true

require 'image_flux'
require 'image_flux/attribute'
require 'image_flux/error'

class ImageFlux::Option
  def self.attributes
    @attributes ||= []
  end

  def self.key_pairs
    @key_pairs ||= {}
  end

  def self.attribute(name, type, options = {}, &block)
    attribute = ImageFlux::Attribute.new(name, type, options)
    attribute.instance_eval(&block) if block_given?
    key_pairs[attribute.name] = attribute
    attribute.aliases.each do |key|
      key_pairs[key] = attribute
    end

    attributes.push(attribute)
  end

  # Predefined prefix path
  attribute :prefix, :string, default: nil, query: false

  # resize attributes
  attribute :w, :integer, default: nil, aliases: %i[width]
  attribute :h, :integer, default: nil, aliases: %i[height]
  attribute :u, :boolean, default: true, aliases: %i[upscale]
  attribute :a, :integer, default: 1, aliases: %i[aspect], enum:{
    scale: 0,
    force_scale: 1,
    crop: 2,
    pad: 3
  }
  attribute :c, :integer_array, default: nil, aliases: %i[crop]
  attribute :cr, :float_array, default: nil, aliases: %i[]
  attribute :g, :integer, default: 4, aliases: %i[gravity], enum: {
    top_left: 1,
    top_center: 2,
    top_right: 3,
    middle_left: 4,
    middle_center: 5,
    middle_right: 6,
    bottom_left: 7,
    bottom_center: 8,
    bottom_right: 9
  }
  attribute :b, :string, default: 'ffffff', aliases: %i[background] do
    validate do |value|
      'b should be a color code' unless value.to_s =~ %r{\A[0-9a-fA-F]{6}\z}
    end
  end
  ALLOWED_ROTATES = %w[1 2 3 4 5 6 7 8 auto]
  attribute :r, :string, default: "1", aliases: %i[rotate] do
    validate do |value|
      "rotate should be inclusion of #{ALLOWED_ROTATES.join(', ')}" unless ALLOWED_ROTATES.include?(value.to_s)
    end
  end
  # overlay attributes
  attribute :l, :string, default: nil
  attribute :lx, :integer, default: nil
  attribute :lxr, :integer, default: nil
  attribute :ly, :integer, default: nil
  attribute :lyr, :integer, default: nil
  attribute :lg, :integer, default: 5, aliases: %i[gravity], enum: {
    top_left: 1,
    top_center: 2,
    top_right: 3,
    middle_left: 4,
    middle_center: 5,
    middle_right: 6,
    bottom_left: 7,
    bottom_center: 8,
    bottom_right: 9
  }
  # output attributes
  ALLOWED_FORMATS = %w[auto jpg png gif webp:jpeg webp:png webp:auto]
  attribute :f, :string, default: 'auto', aliases: %i[format] do
    validate do |value|
      "format should be inclusion of #{ALLOWED_FORMATS.join(', ')}" unless ALLOWED_FORMATS.include?(value.to_s)
    end
  end
  attribute :q, :integer, default: 75, aliases: %i[quality]
  attribute :o, :boolean, default: true, aliases: %i[optimize]
  attribute :t, :string, default: nil, aliases: %i[through]

  attribute :sig, :nonescape_string, default: nil

  def initialize(options = {})
    @values = {}

    options.each_pair do |key, val|
      key = key.to_s.to_sym
      attribute = self.class.key_pairs[key]
      @values[attribute] = val if attribute
    end
  end

  def prefix_path
    prefix_attr = self.class.key_pairs[:prefix]
    @values[prefix_attr]
  end

  def to_query(ignore_default: true)
    errors = []
    queries = @values.to_a.map do |pair|
      attribute = pair.first
      value = pair.last
      errors.concat(attribute.validate!(value))
      attribute.querize(value)
    end
    raise ImageFlux::InvalidOptionError, errors.join(', ') unless errors.length.zero?

    queries.reject(&:nil?).join(',')
  end
end
