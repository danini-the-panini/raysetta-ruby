# frozen_string_literal: true

module Raysetta
  module Object
    class MovingSphere < Sphere
      attr_accessor :center_vec

      def initialize(center1, center2, radius, material)
        super(center1, radius, material)
        @center_vec = center2 - center1
        rvec = Vec3.new(radius, radius, radius)
        box1 = AABB.from_points(center1 - rvec, center1 + rvec)
        box2 = AABB.from_points(center2 - rvec, center2 + rvec)
        @bounding_box = AABB.from_aabbs(box1, box2)
      end

      # Linearly interpolate from center1 to center2 according to time, where t=0 yields
      # center1, and t=1 yields center2.
      def center_at(time = 0.0)
        center + center_vec * time
      end

      def hit(r, ray_t, center = center_at(r.time))
        super(r, ray_t, center)
      end

      def export
        {
          **super.except(:center),
          center1: center.to_a,
          center2: center_at(1.0).to_a
        }
      end

      def to_s(depth=0)
        indent = "  "*depth
        "#{indent}MovingSphere { radius=#{radius}, center=#{center}, vec=#{center_vec} }"
      end
    end
  end
end
