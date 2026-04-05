# frozen_string_literal: true

module Raysetta
  module Object
    class BVH < Base
      attr_reader :bounding_box

      def initialize(objects)
        self.objects = objects
      end

      def hit(r, ray_t)
        return nil unless bounding_box.hit(r, ray_t)

        hit_left = @left.hit(r, ray_t)
        hit_right = @right.hit(r, ray_t.min..(hit_left&.t || ray_t.max))

        hit_right || hit_left
      end

      def export
        { **export_bvh(@left), **export_bvh(@right) }
      end

      def materials
        [*@left.materials, *@right.materials].uniq
      end

      def objects
        @left.objects | @right.objects
      end

      def objects=(objs)
        @bounding_box = AABB::EMPTY
        objs.each do |object|
          @bounding_box = AABB.from_aabbs(@bounding_box, object.bounding_box)
        end

        axis = @bounding_box.longest_axis

        case objs.length
        when 1
          @left = @right = objs[0]
        when 2
          @left = objs[0]
          @right = objs[1]
        else
          objs.sort_by! { _1.bounding_box[axis].min }
          mid = objs.length / 2
          left_objs = objs[0...mid] #: Array[Object::Base]
          right_objs = objs[mid..] #: Array[Object::Base]
          @left = BVH.new(left_objs)
          @right = BVH.new(right_objs)
        end
      end

      def add(object)
        self.objects = objects + [object]
      end

      def to_s(depth=0)
        indent = "  "*depth
        "#{indent}BVH {\n" +
        "#{indent}  left=\n"+
        "#{@left.to_s(depth+2)}\n"+
        "#{indent}  right=\n"+
        "#{@right.to_s(depth+2)}\n"+
        "#{indent}}"
      end

      private

        def export_bvh(obj)
          case obj
          when BVH then obj.export
          else { obj.id => obj.export }
          end
        end
    end
  end
end
