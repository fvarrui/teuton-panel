# frozen_string_literal: true

require "test_helper"

class LangTest < Test::Unit::TestCase
  def keys_of(hash, prefix = "")
    hash.flat_map do |key, value|
      path = prefix.empty? ? key : "#{prefix}.#{key}"
      value.is_a?(Hash) ? keys_of(value, path) : [path]
    end
  end

  test "every language has the same keys" do
    texts = Teuton::Panel::Lang.texts
    assert_equal keys_of(texts["en"]).sort, keys_of(texts["es"]).sort
    assert_equal keys_of(texts["en"]).sort, keys_of(texts["ca"]).sort
  end

  test "translate with variables" do
    text = Teuton::Panel::Lang.t("es", "students.code_is", code: "K7QH")
    assert_match "K7QH", text
  end

  test "detect language from Accept-Language" do
    assert_equal "es", Teuton::Panel::Lang.detect("es-ES,es;q=0.9,en;q=0.8", "en")
    assert_equal "en", Teuton::Panel::Lang.detect("en-US,en;q=0.9", "es")
    assert_equal "es", Teuton::Panel::Lang.detect("fr-FR,fr;q=0.9", "es")
    assert_equal "ca", Teuton::Panel::Lang.detect("ca-ES,ca;q=0.9,es;q=0.8", "en")
    assert_equal "en", Teuton::Panel::Lang.detect(nil, "en")
  end
end
