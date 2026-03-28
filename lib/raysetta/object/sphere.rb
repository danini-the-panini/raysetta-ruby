# frozen_string_literal: true

module Raysetta
  module Object
    class Sphere < Base
      attr_accessor :center, :radius, :material

      attr_reader :bounding_box

      def initialize(center, radius, material)
        @center = center
        @radius = radius
        @material = material
        rvec = Vec3.new(radius, radius, radius)
        @bounding_box = AABB.from_points(center - rvec, center + rvec)
      end

      def hit(r, ray_t, center = @center)
        oc = center - r.origin
        a = r.direction.length_squared
        h = r.direction.dot(oc)
        c = oc.length_squared - radius**2

        discriminant = h**2 - a*c
        return nil if discriminant < 0

        sqrtd = Math.sqrt(discriminant)

        # Find the nearest root that lies in the acceptable range.
        root = (h - sqrtd) / a
        unless ray_t.cover?(root)
          root = (h + sqrtd) / a
          return nil unless ray_t.cover?(root)
        end

        point = r.at(root)
        normal = (point - center).div(radius)

        Hit.new(
          point:,
          r:,
          normal:,
          t: root,
          material:,
          uv: Util.sphere_uv(normal)
        )
      end

      def export
        {
          **super,
          center: center.to_a,
          radius: radius,
          material: material.id
        }
      end

      def materials
        [material]
      end

      def to_s(depth=0)
        indent = "  "*depth
        "#{indent}Sphere { radius=#{radius}, center=#{center} }"
      end
    end
  end
end
