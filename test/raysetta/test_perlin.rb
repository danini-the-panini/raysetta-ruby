# frozen_string_literal: true

require "test_helper"

class TestPerlin < Minitest::Test
  def perlin
    @perlin ||= begin
        import = JSON.parse(File.read("test/fixtures/perlin.json"))
        Raysetta::Perlin.new(
          import["randvec"].map { vec3(*_1) },
          import["perm_x"],
          import["perm_y"],
          import["perm_z"]
        )
      end
  end

  def test_noise
    assert_in_delta(-0.04622544629246537, perlin.noise(vec3(0.1, 0.1, 0.1)), Raysetta::Vec3::EPSILON)
    assert_in_delta(-0.012540283862857101, perlin.noise(vec3(1.1, 0.1, 0.1)), Raysetta::Vec3::EPSILON)
    assert_in_delta(0.18181925381251057, perlin.noise(vec3(0.1, 1.1, 0.1)), Raysetta::Vec3::EPSILON)
    assert_in_delta(-0.18654193387951584, perlin.noise(vec3(0.1, 0.1, 1.1)), Raysetta::Vec3::EPSILON)
    assert_in_delta(-0.13154809954349786, perlin.noise(vec3(-1.1, 0.1, 0.1)), Raysetta::Vec3::EPSILON)
    assert_in_delta(-0.025795820720820983, perlin.noise(vec3(0.1, -1.1, 0.1)), Raysetta::Vec3::EPSILON)
    assert_in_delta(0.06715251051503039, perlin.noise(vec3(0.1, 0.1, -1.1)), Raysetta::Vec3::EPSILON)
    assert_in_delta(-0.16822594816523573, perlin.noise(vec3(14.23, -12.7, 22.9)), Raysetta::Vec3::EPSILON)
  end

  def test_turb
    assert_in_delta(0.1823456737790779, perlin.turb(vec3(0.1, 0.1, 0.1), 3), Raysetta::Vec3::EPSILON)
    assert_in_delta(0.08277404031514893, perlin.turb(vec3(1.1, 0.1, 0.1), 3), Raysetta::Vec3::EPSILON)
    assert_in_delta(0.2263034505521392, perlin.turb(vec3(0.1, 1.1, 0.1), 3), Raysetta::Vec3::EPSILON)
    assert_in_delta(0.004011034868672533, perlin.turb(vec3(0.1, 0.1, 1.1), 3), Raysetta::Vec3::EPSILON)
    assert_in_delta(0.22401491156674008, perlin.turb(vec3(-1.1, 0.1, 0.1), 3), Raysetta::Vec3::EPSILON)
    assert_in_delta(0.09552910970458893, perlin.turb(vec3(0.1, -1.1, 0.1), 3), Raysetta::Vec3::EPSILON)
    assert_in_delta(0.07459185313278975, perlin.turb(vec3(0.1, 0.1, -1.1), 3), Raysetta::Vec3::EPSILON)
    assert_in_delta(0.29020655550312313, perlin.turb(vec3(14.23, -12.7, 22.9), 3), Raysetta::Vec3::EPSILON)
  end

  def test_export
    assert_equal(
      JSON.parse(File.read("test/fixtures/perlin.json"), symbolize_names: true),
      perlin.export
    )
  end
end
