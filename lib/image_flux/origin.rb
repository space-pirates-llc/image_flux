require 'uri'
require 'image_flux'

class ImageFlux::Origin
  def initialize(domain: , scheme: 'https', **options)
    @domain = domain.to_s
    @scheme = scheme.to_s
  end

  def base_url
    @base_url ||= URI("#{@scheme}://#{@domain}/")
  end
end
