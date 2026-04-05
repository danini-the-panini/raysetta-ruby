# frozen_string_literal: true

module Raysetta
  class Tracer
    attr_reader :scene, :width, :height, :samples_per_pixel, :max_depth

    def initialize(scene, width: 256, height: 256, samples_per_pixel: 10, max_depth: 10)
      @scene = scene
      @width = width
      @height = height
      @samples_per_pixel = samples_per_pixel
      @max_depth = max_depth
      @pixel_sample_scale = 1.0 / samples_per_pixel

      scene.camera.viewport(width, height)
    end

    def call(x, y)
      pixel_color = Vec3.new
      samples_per_pixel.times do
        pixel_color.add(ray_color(scene.camera.ray(x, y)))
      end
      pixel_color.mul(@pixel_sample_scale).to_pixel
    end

    def ray_color(r, depth = max_depth)
      # If we've exceeded the ray bounce limit, no more light is gathered.
      return Vec3.new unless depth > 0

      rec = scene.world.hit(r, 0.001..Float::INFINITY)
      # If the ray hits nothing, return the background color.
      return scene.background.sample(r) unless rec

      emitted = rec.material.emitted(rec.uv, rec.point)
      scatter = rec.material.scatter(r, rec)
      return emitted unless scatter

      scattered = ray_color(scatter.ray, depth - 1).times(scatter.attenuation)

      emitted + scattered
    end
  end
end
