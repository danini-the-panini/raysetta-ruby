# frozen_string_literal: true

module Raysetta
  module Object
    class Group < Base
      attr_reader :objects, :bounding_box

      def initialize(*objects)
        self.objects = objects
      end

      def objects=(objs)
        @objects = objs
        @bounding_box = AABB.from_aabbs(*objs.map(&:bounding_box))
      end

      def add(obj)
        @objects << obj
        @bounding_box = AABB.from_aabbs(@bounding_box, obj.bounding_box)
      end

      def hit(r, ray_t)
        hit = nil #: Hit?
        closest_so_far = ray_t.max

        @objects.each do |object|
          if tmp = object.hit(r, ray_t.min..closest_so_far)
            hit = tmp
            # @type var hit: Hit
            closest_so_far = hit.t
          end
        end

        hit
      end

      def export
        {
          **super,
          objects: objects.map { [_1.id, _1.export] }.to_h
        }
      end

      def materials
        @objects.flat_map(&:materials).uniq
      end

      def to_s(depth=0)
        indent = "  "*depth
        "#{indent}Group {\n" +
        "#{indent}  objects = {" +
        "#{@objects.map { _1.to_s(depth+2)+"\n" } }" +
        "#{indent}  }\n" +
        "#{indent}}"
      end

    end
  end
end
