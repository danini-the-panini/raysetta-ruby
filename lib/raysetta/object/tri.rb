# frozen_string_literal: true

module Raysetta
  module Object
    class Tri < Quad
      def initialize(a, b, c, material)
        super(a, b - a, c - a, material)
        # TODO: uv coordinates
        # TODO: front face based on clockwizeness of points
      end

      def export
        {
          **super,
          a: q.to_a,
          b: (q + u).to_a,
          c: (q + v).to_a,
          material: material.id
        }
      end

      def to_s(depth=0)
        indent = "  "*depth
        "#{indent}Triangle { a=#{q}, b=#{q + u}, c=#{q + v} }"
      end

      private

        def interior?(a, b)
          # Given the hit point in plane coordinates, return nil if it is outside the
          # primitive, otherwise return the UV coordinates.

          return unless a > 0.0 && b > 0.0 && a + b < 1.0

          # TODO: uv coordinates
          Vec2.new(a, b)
        end

        def compute_bounding_box
          # Compute the bounding box of all three vertices.
          @bounding_box = AABB.from_points(q, q + u, q + v);
        end

    end
  end
end
