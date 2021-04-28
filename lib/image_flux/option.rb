# frozen_string_literal: true

require 'image_flux'
require 'image_flux/attribute'
require 'image_flux/error'

class ImageFlux::Option
  REGEXP_INTEGER = %r{\d+}
  REGEXP_FLOAT = %r{\d+(?:\.\d+)?}

  REGEXP_UNSHARP = %r{\A#{REGEXP_INTEGER}x#{REGEXP_FLOAT}(?:\+#{REGEXP_FLOAT}){1,2}\z}x
  REGEXP_BLUR = %r{\A#{REGEXP_INTEGER}x#{REGEXP_FLOAT}\z}x
  REGEXP_MASK = %r{\A(?:white|black|alpha)(?::[01])?\z}

  def self.attributes
    @attributes ||= []
  end

  def self.key_pairs
    @key_pairs ||= {}
  end

  def self.attribute(name, type, options = {}, &block)
    attribute = ImageFlux::Attribute.new(name, type, **options)
    attribute.instance_eval(&block) if block_given?
    key_pairs[attribute.name] = attribute
    attribute.aliases.each do |key|
      key_pairs[key] = attribute
    end
    names = [name] + (options[:aliases] || [])
    names.each do |name|
      define_method(:"#{name}") { @values[attribute] }
      define_method(:"#{name}=") { |val| @values[attribute] = val }
    end

    attributes.push(attribute)
  end

  # Predefined prefix path
  attribute :prefix, :string, default: nil, query: false

  # scaling attributes
  # https://console.imageflux.jp/docs/image/conversion-parameters#scaling
  attribute :w, :integer, default: nil, aliases: %i[width]
  attribute :h, :integer, default: nil, aliases: %i[height]
  attribute :a, :integer, default: 1, aliases: %i[aspect], enum:{
    scale: 0,
    force_scale: 1,
    crop: 2,
    pad: 3
  }
  attribute :b, :string, default: 'ffffff', aliases: %i[background] do
    validate do |value|
      'b should be a color code' unless value.to_s =~ %r{\A[0-9a-fA-F]{6}\z}
    end
  end
  attribute :c, :integer_array, default: nil, aliases: %i[crop]
  attribute :g, :integer, default: 5, aliases: %i[gravity], enum: {
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
  attribute :u, :boolean, default: true, aliases: %i[upscale]

  # clipping attributes
  # ref: https://console.imageflux.jp/docs/image/conversion-parameters#clipping
  attribute :ic, :integer_array, default: nil, aliases: %i[input_clipping]
  attribute :icr, :float_array, default: nil, aliases: %i[input_clipping_range]
  attribute :ig, :integer, default: nil, aliases: %i[input_gravity], enum: {
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
  attribute :c, :integer_array, default: nil, aliases: %i[oc output_clipping]
  attribute :cr, :float_array, default: nil, aliases: %i[ocr output_clipping_range]
  attribute :og, :integer, default: nil, aliases: %i[output_gravity], enum: {
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

  # rotation attributes
  # ref: https://console.imageflux.jp/docs/image/conversion-parameters#rotation
  ALLOWED_ROTATES = %w[1 2 3 4 5 6 7 8 auto].freeze
  attribute :ir, :string, default: '1', aliases: %i[input_rotate] do
    validate do |value|
      "rotate should be inclusion of #{ALLOWED_ROTATES.join(', ')}" unless ALLOWED_ROTATES.include?(value.to_s)
    end
  end
  attribute :r, :string, default: '1', aliases: %i[or rotate output_rotate] do
    validate do |value|
      "rotate should be inclusion of #{ALLOWED_ROTATES.join(', ')}" unless ALLOWED_ROTATES.include?(value.to_s)
    end
  end

  # filter attributes
  # ref: https://console.imageflux.jp/docs/image/conversion-parameters#filter
  attribute :unsharp, REGEXP_UNSHARP, default: nil, aliases: %i[]
  attribute :blur, REGEXP_BLUR, default: nil, aliases: %i[]
  attribute :grayscale, :integer, default: nil, aliases: %i[]
  attribute :sepia, :integer, default: nil, aliases: %i[]
  attribute :brightnes, :integer, default: nil, aliases: %i[]
  attribute :contrast, :integer, default: nil, aliases: %i[]
  attribute :invert, :integer, default: nil, aliases: %i[]

  # overlay attribute
  attribute :overlay, :overlay, default: nil
  attribute :path, :path, default: nil
  attribute :x, :integer, default: 0
  attribute :xr, :float, default: nil
  attribute :y, :integer, default: 0
  attribute :yr, :float, default: nil
  attribute :lg, :integer, default: 5, aliases: %i[], enum: {
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
  attribute :mask, REGEXP_MASK, default: nil

  # old overlay attributes
  # ref: https://console.imageflux.jp/docs/image/conversion-parameters#%E7%94%BB%E5%83%8F%E4%BD%8D%E7%BD%AE%E3%81%AE%E6%8C%87%E5%AE%9A-%E5%8F%A4%E3%81%84%E5%BD%A2%E5%BC%8F
  attribute :l, :string, default: nil
  attribute :lx, :integer, default: nil
  attribute :lxr, :integer, default: nil
  attribute :ly, :integer, default: nil
  attribute :lyr, :integer, default: nil
  attribute :lg, :integer, default: 5, aliases: %i[], enum: {
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
  # ref: https://console.imageflux.jp/docs/image/conversion-parameters#output
  ALLOWED_FORMATS = %w[auto jpg png gif webp:jpeg webp:png webp:auto].freeze
  attribute :f, :string, default: 'auto', aliases: %i[format] do
    validate do |value|
      "format should be inclusion of #{ALLOWED_FORMATS.join(', ')}" unless ALLOWED_FORMATS.include?(value.to_s)
    end
  end
  attribute :q, :integer, default: 75, aliases: %i[quality]
  attribute :o, :boolean, default: true, aliases: %i[optimize]
  attribute :lossless, :boolean, default: nil, aliases: %i[]
  attribute :s, :integer, default: 1, aliases: %i[strip], enum: {
    strip: 1,
    strip_without_orientation: 2,
  }

  # through attributes
  # https://console.imageflux.jp/docs/image/conversion-parameters#through
  ALLOWED_THROUGH_FORMATS = %w[jpg png gif]
  attribute :t, :string, aliases: %i[through] do
    validate do |value|
      values = values.to_s.split(':')
      "format should be inclusion of #{ALLOWED_THROUGH_FORMATS.join(', ')}" unless values.all? { |format| ALLOWED_THROUGH_FORMATS.includes?(format) }
    end
  end

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

  def to_query
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

  def to_h
    hash = {}
    @values.each_pair do |attribute, val|
      hash[attribute.name] = val
    end
    hash
  end

  def merge(other)
    to_h.merge(other)
  end
end
