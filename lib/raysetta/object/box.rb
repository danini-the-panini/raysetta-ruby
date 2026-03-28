# frozen_string_literal: true

module Raysetta
  module Object
    class Box < Group
      def self.new(*args)
        super(*args, bvh: false)
      end

      def initialize(a, b, material)
        @a = a
        @b = b
        @material = material

        # Returns the 3D box (six sides) that contains the two opposite vertices a & b.

        sides = []
    
        # Construct the two opposite vertices with the minimum and maximum coordinates.
        min = Point3.new([a.x, b.x].min, [a.y, b.y].min, [a.z, b.z].min);
        max = Point3.new([a.x, b.x].max, [a.y, b.y].max, [a.z, b.z].max);
    
        dx = Vec3.new(max.x - min.x, 0.0, 0.0)
        dy = Vec3.new(0.0, max.y - min.y, 0.0)
        dz = Vec3.new(0.0, 0.0, max.z - min.z)
    
        sides << (Quad.new(Point3.new(min.x, min.y, max.z),  dx,  dy, material)) # front
        sides << (Quad.new(Point3.new(max.x, min.y, max.z), -dz,  dy, material)) # right
        sides << (Quad.new(Point3.new(max.x, min.y, min.z), -dx,  dy, material)) # back
        sides << (Quad.new(Point3.new(min.x, min.y, min.z),  dz,  dy, material)) # left
        sides << (Quad.new(Point3.new(min.x, max.y, max.z),  dx, -dz, material)) # top
        sides << (Quad.new(Point3.new(min.x, min.y, min.z),  dx,  dz, material)) # bottom

        super(*sides)
      end

      def export
        {
          type: "Box",
          a: @a.to_a,
          b: @b.to_a,
          material: @material.id
        }
      end

      def materials
        [@material]
      end

      def to_s(depth=0)
        indent = "  "*depth
        "#{indent}Box { a=#{@a}, b=#{@b} }"
      end
    end
  end
end
