# frozen_string_literal: true

module Raysetta
  module Texture
    class Image < Base
      attr_accessor :image

      def initialize(image)
        @image = image
      end

      def sample(uv, point)
        # Clamp input texture coordinates to [0,1] x [1,0]
        u = uv.u.clamp(0.0, 1.0)
        v = 1.0 - uv.v.clamp(0.0, 1.0)

        x = u*image.width + 0.5
        y = v*image.height + 0.5

        x1 = x.floor
        y1 = y.floor

        x2 = x.ceil
        y2 = y.ceil

        x2 = x1+1 if x2 == x1
        y2 = y1+1 if y2 == y1
        
        q11 = image[x1.to_i, y1.to_i]
        q12 = image[x1.to_i, y2.to_i]
        q21 = image[x2.to_i, y1.to_i]
        q22 = image[x2.to_i, y2.to_i]

        (q11*(x2-x)*(y2-y)+q21*(x-x1)*(y2-y)+q12*(x2-x)*(y-y1)+q22*(x-x1)*(y-y1)) / ((x2-x1)*(y2-y1)).to_f
      end

      def ==(tex)
        image == tex.image
      end

      def hash
        [type, image].hash
      end

      def export
        {
          **super,
          image: image.id
        }
      end

      def images
        [image]
      end
    end
  end
end
