# frozen_string_literal: true

module Raysetta
  class Hit
    attr_accessor :point, :normal, :t, :material, :uv
    attr_writer :front_face

    def initialize(
      t:,
      normal:,
      material:,
      r: nil,
      point: ray.at(t),
      uv: Vec2.new
    )
      @point = point
      @t = t
      @material = material
      @uv = uv
      @normal = normal
      @front_face = true

      set_face_normal(r) if r
    end

    def front_face? = @front_face

    private

      # Sets the hit's normal vector.
      # NOTE: `@normal` is assumed to have unit length.
      def set_face_normal(r)
        @front_face = r.direction.dot(@normal) < 0
        @normal = @front_face ? @normal : -@normal
      end

  end
end
