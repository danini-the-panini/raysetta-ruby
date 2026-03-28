# frozen_string_literal: true

require "test_helper"

class TestScene < Minitest::Test
  def test_parse
    scene = Raysetta::Scene.parse(JSON.parse(File.read("test/fixtures/scene.json")))

    refute_nil scene
    assert_kind_of Raysetta::Scene, scene
  end
end
