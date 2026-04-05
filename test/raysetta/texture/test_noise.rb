# frozen_string_literal: true

require "test_helper"

class TestNoiseTexture < Minitest::Test
  def loadperlin(name)
    import = JSON.parse(File.read("test/fixtures/#{name}.json"))
    Raysetta::Perlin.new(
      import["randvec"].map { vec3(*_1) },
      import["perm_x"],
      import["perm_y"],
      import["perm_z"]
    )
  end

  def perlin
    @perlin ||= loadperlin("perlin")
  end

  def perlin2
    @perlin2 ||= loadperlin("perlin2")
  end

  def test_sample
    tex = Raysetta::Texture::Noise.new(1.0, 1, nil, perlin)
    assert_equal rgb(0.04622544, 0.04622544, 0.04622544), tex.sample(nil, vec3(0.1, 0.1, 0.1))

    tex = Raysetta::Texture::Noise.new(1.0, 1, :y, perlin)
    assert_equal rgb(0.76654747, 0.76654747, 0.76654747), tex.sample(nil, vec3(0.1, 0.1, 0.1))
    assert_equal rgb(0.99755478, 0.99755478, 0.99755478), tex.sample(nil, vec3(0.2, 0.2, 0.2))
    assert_equal rgb(0.99987716, 0.99987716, 0.99987716), tex.sample(nil, vec3(14.23, -12.7, 22.9))

    tex = Raysetta::Texture::Noise.new(4.0, 7, :z, perlin2)
    assert_equal rgb(0.18852516, 0.18852516, 0.18852516), tex.sample(nil, vec3(0.1, 0.1, 0.1))
    assert_equal rgb(0.00034500, 0.00034500, 0.00034500), tex.sample(nil, vec3(0.2, 0.2, 0.2))
    assert_equal rgb(0.11661256, 0.11661256, 0.11661256), tex.sample(nil, vec3(14.23, -12.7, 22.9))
    assert_equal rgb(0.48861572, 0.48861572, 0.48861572), tex.sample(nil, vec3(6.621070131320098, -0.022072913018541307, 0.5538674387725755))
  end

  def test_export
    noise = OpenStruct.new(id: "some-noise")
    assert_equal({
      type: "Noise",
      scale: 1.1,
      depth: 7,
      marble_axis: "y",
      noise: "some-noise",
    }, Raysetta::Texture::Noise.new(1.1, 7, :y, noise).export)
  end
end
