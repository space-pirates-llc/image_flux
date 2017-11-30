# frozen_string_literal: true

require 'image_flux/version'
require 'image_flux/origin'
require 'image_flux/option'

module ImageFlux
  class << self
    attr_accessor :default_origin

    def image_url(path, options = {})
      default_origin.image_url(path, options)
    end
  end
end
