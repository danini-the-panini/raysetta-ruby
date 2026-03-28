# frozen_string_literal: true

require "json"

module Raysetta
  class Scene
    attr_accessor :world, :camera, :background

    def initialize(world, camera, background)
      @world = world
      @camera = camera
      @background = background
    end

    def self.parse(json)
      Parser.new(json).parse
    end

    def export
      all_materials = world.materials
      all_textures = [*all_materials, background].flat_map(&:textures).uniq
      all_images = all_textures.flat_map(&:images).uniq
      all_noises = all_textures.flat_map(&:noises).uniq
      {
        world: world.export,
        camera: camera.export,
        background: background.export,
        materials: export_by_id(all_materials),
        textures: export_by_id(all_textures),
        images: export_by_id(all_images),
        noises: export_by_id(all_noises)
      }
    end

    private

    def export_by_id(entities)
      entities.each_with_object({}) do |entity, exported|
        exported[entity.id] = entity.export
      end
    end

    class Parser
      class Error < Raysetta::Error; end

      attr_reader :json

      def initialize(json)
        @json = json
      end

      def parse
        @noises = json["noises"].transform_values { parse_noise(_1) }
        @images = json["images"].transform_values { parse_image(_1) }
        @textures = json["textures"].transform_values { parse_texture(_1) }
        @materials = json["materials"].transform_values { parse_material(_1) }
        world = parse_world(json["world"])
        camera = parse_camera(json["camera"])
        background = parse_background(json["background"])

        Scene.new(world, camera, background)
      end

      def parse_noise(noise)
        Perlin.new(
          noise["randvec"].map { Vec3.new(*_1) },
          noise["perm_x"],
          noise["perm_y"],
          noise["perm_z"]
        )
      end

      def parse_image(img)
        Image.new(data_url: img["data"])
      end

      def parse_texture(tex)
        case tex["type"]
        when "SolidColor" then Texture::SolidColor.new(Color.new(*tex["albedo"]))
        when "Checker" then Texture::Checker.new(tex["scale"], parse_texture(tex["even"]), parse_texture(tex["odd"]))
        when "Image" then Texture::Image.new(image(tex["image"]))
        when "Noise" then Texture::Noise.new(tex["scale"], tex["depth"], tex["marble_axis"]&.to_sym, noise(tex["noise"]))
        else raise Error, "unknown texture type #{tex["type"]}"
        end
      end

      def parse_material(mat)
        case mat["type"]
        when "Lambertian" then Material::Lambertian.new(texture(mat["texture"]))
        when "Metal" then Material::Metal.new(texture(mat["texture"]), mat["fuzz"])
        when "Dielectric" then Material::Dielectric.new(mat["refraction_index"])
        when "DiffuseLight" then Material::DiffuseLight.new(texture(mat["texture"]))
        else raise Error, "unknown material type #{mat["type"]}"
        end
      end

      def parse_world(json)
        Object::BVH.new(json.map { |_, v| parse_object(v) })
      end

      def parse_object(obj)
        case obj["type"]
        when "Sphere" then parse_sphere(obj)
        when "MovingSphere" then parse_moving_sphere(obj)
        when "Quad" then parse_quad(obj)
        when "Tri" then parse_tri(obj)
        when "Box" then parse_box(obj)
        else raise Error, "unknown object type #{obj["type"]}"
        end
      end

      def parse_sphere(obj)
        Object::Sphere.new(Point3.new(*obj["center"]), obj["radius"], material(obj["material"]))
      end

      def parse_moving_sphere(obj)
        Object::MovingSphere.new(Point3.new(*obj["center1"]), Point3.new(*obj["center2"]), obj["radius"], material(obj["material"]))
      end

      def parse_quad(obj)
        Object::Quad.new(Point3.new(*obj["q"]), Vec3.new(*obj["u"]), Vec3.new(*obj["v"]), material(obj["material"]))
      end

      def parse_tri(obj)
        Object::Tri.new(Point3.new(*obj["a"]), Vec3.new(*obj["b"]), Vec3.new(*obj["c"]), material(obj["material"]))
      end

      def parse_box(obj)
        Object::Box.new(Point3.new(*obj["a"]), Vec3.new(*obj["b"]), material(obj["material"]))
      end

      def material(name)
        raise Error, "unknown material #{name}" unless @materials.key?(name)

        @materials[name]
      end

      def texture(name)
        raise Error, "unknown texture #{name}" unless @textures.key?(name)

        @textures[name]
      end

      def image(name)
        raise Error, "unknown image #{name}" unless @images.key?(name)

        @images[name]
      end

      def noise(name)
        raise Error, "unknown noise #{name}" unless @noises.key?(name)

        @noises[name]
      end

      def parse_camera(cam)
        args = {}
        args[:vfov] = cam["vfov"] if cam.key?("vfov")
        args[:lookfrom] = Point3.new(*cam["lookfrom"]) if cam.key?("lookfrom")
        args[:lookat] = Point3.new(*cam["lookat"]) if cam.key?("lookat")
        args[:vup] = Vec3.new(*cam["vup"]) if cam.key?("vup")
        args[:defocus_angle] = cam["defocus_angle"] if cam.key?("defocus_angle")
        args[:focus_dist] = cam["focus_dist"] if cam.key?("focus_dist")
        Camera.new(**args)
      end

      def parse_background(bg)
        case bg["type"]
        when "Solid" then parse_solid_bg(bg)
        when "Gradient" then parse_gradient_bg(bg)
        when "SphereMap" then parse_sphere_map(bg)
        when "CubeMap" then parse_cube_map(bg)
        else raise Error, "unknown background type #{bg["type"]}"
        end
      end

      def parse_solid_bg(bg)
        Background::Solid.new(Color.new(*bg["albedo"]))
      end

      def parse_gradient_bg(bg)
        Background::Gradient.new(Color.new(*bg["top"]), Color.new(*bg["bottom"]))
      end

      def parse_sphere_map(bg)
        Background::SphereMap.new(texture(bg["texture"]))
      end

      def parse_cube_map(bg)
        Background::CubeMap.new(*bg["textures"].map { texture(_1) })
      end
    end
  end
end
