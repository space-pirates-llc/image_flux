# frozen_string_literal: true

require 'image_flux'

class ImageFlux::Error < StandardError
end

class ImageFlux::InvalidOptionError < ImageFlux::Error
end
