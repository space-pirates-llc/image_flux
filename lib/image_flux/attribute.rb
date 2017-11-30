# frozen_string_literal: true

require 'erb'
require 'image_flux'

class ImageFlux::Attribute
  def initialize(name, type, default: nil, aliases: [], enum: nil, query: true)
    @name = name.to_s.to_sym
    @type = type
    @default = default
    @aliases = aliases.flatten.map { |a| a.to_s.to_sym }.uniq
    @enum = enum
    @validators = []
    @query = query
  end
  attr_reader :name, :type, :default, :aliases

  def validate(&block)
    @validators.push(block)
  end

  def expand(value)
    @enum ? @enum.fetch(value) { value } : value
  end

  def querize(value, ignore_default: true)
    value = expand(value)
    return nil if !@query || (ignore_default && default == value)

    value = case type
            when :string
              ERB::Util.url_encode(value.to_s)
            when :integer
              value.to_i.to_s
            when :float
              value.to_f.to_s
            when :integer_array
              value.map(&:to_i).join(':')
            when :float_array
              value.map(&:to_f).join(':')
            when :boolean
              value ? '1' : '0'
            else
              value
            end

    "#{name}=#{value}"
  end

  def validate!(value)
    errors = []
    value = expand(value)
    errors.push(validate_type(value))
    @validators.each do |validator|
      errors.push(validator.call(value))
    end
    errors.reject(&:nil?)
  end

  def validate_type(value)
    check = case type
            when :string
              value.is_a?(String) || value.respond_to?(:to_s)
            when :integer
              value.is_a?(Integer) || value.respond_to?(:to_i)
            when :float
              value.is_a?(Float) || value.respond_to?(:to_f)
            when :integer_array
              value.is_a?(Array) && value.all? { |elem| elem.is_a?(Integer) || elem.respond_to?(:to_i) }
            when :float_array
              value.is_a?(Array) && value.all? { |elem| elem.is_a?(Float) || elem.respond_to?(:to_i) }
            when :boolean
              value.is_a?(TrueClass) || value.is_a?(FalseClass)
            else
              true
            end

    return "#{name} is invalid type(expected be a #{type})" unless check
  end
end
