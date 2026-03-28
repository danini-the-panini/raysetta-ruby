# frozen_string_literal: true

require 'chunky_png'

module Raysetta
  class Image < EntityBase
    attr_reader :image

    def initialize(path: nil, data_url: nil)
      @image = if path
        ChunkyPNG::Image.from_file(path)
      elsif data_url
        ChunkyPNG::Image.from_data_url(data_url)
      else
        raise ArgumentError, "missing path or data_url"
      end
    end
  
    def width = image.width
    def height = image.height

    def [](x, y)
      pixel = image.get_pixel(x.clamp(0, width-1), y.clamp(0, height-1))
      Color.new(ChunkyPNG::Color.r(pixel)/255.0, ChunkyPNG::Color.g(pixel)/255.0, ChunkyPNG::Color.b(pixel)/255.0).tap do |c|
        c.r = Util.gamma_to_linear(c.r)
        c.g = Util.gamma_to_linear(c.g)
        c.b = Util.gamma_to_linear(c.b)
      end
    end

    def ==(img)
      image == img.image
    end

    def hash
      [type, image].hash
    end

    def export
      {
        **super,
        data: image.to_data_url
      }
    end
  end
end
