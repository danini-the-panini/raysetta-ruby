# frozen_string_literal: true

require "test_helper"

class TestEntityBase < Minitest::Test
  def entity
    @entity ||= Raysetta::EntityBase.new
  end

  def test_id
    assert_match(/entitybase-[a-z0-9]+/, entity.id)
  end

  def test_type
    assert_equal "EntityBase", entity.type
  end

  def test_equals
    assert_equal entity, entity
    refute_equal entity, Raysetta::EntityBase.new
  end

  def test_export
    assert_equal({ type: "EntityBase" }, entity.export)
  end
end
