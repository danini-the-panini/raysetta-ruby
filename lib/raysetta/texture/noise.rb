# frozen_string_literal: true

module Raysetta
  module Texture
    class Noise < Base
      attr_accessor :scale, :depth, :marble_axis

      def initialize(scale, depth, marble_axis, noise=Perlin.new)
        @scale = scale
        @depth = depth
        @marble_axis = marble_axis
        @noise = noise
      end

      def sample(uv, point)
        if marble_axis
          Color.repeat(0.5) * (1.0 + Math.sin(scale * point.send(marble_axis) + 10.0 * @noise.turb(point, depth)))
        else
          Color.repeat(1.0) * @noise.turb(point, depth)
        end
      end

      def ==(tex)
        scale == tex.scale &&
        depth == tex.depth &&
        marble_axis == tex.marble_axis &&
        noise == tex.noise
      end

      def hash
        [scale, depth, marble_axis, noise].hash
      end

      def export
        { **super, scale:, depth:, marble_axis: marble_axis.to_s, noise: @noise.id }
      end

      def noises
        [@noise]
      end

      protected
      attr_reader :noise
    end
  end
end
