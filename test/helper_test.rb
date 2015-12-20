require 'test_helper'


class HelperTest < Minitest::Test

  def test_includes_hash
    a = { :a => 1, :b => { :bb => 22, :cc => { :dd => 44, :ee => 55 }}, :c => 3}
    assert_includes_hash a, { :a => 1 }
    assert_includes_hash a, { :b => { :bb => 22 }}
    assert_includes_hash a, { :b => { :cc => { :dd => 44 }}}
    assert_includes_hash a, { :a => 1, :c => 3 }

    refute_includes_hash a, { :a => 2 }
    refute_includes_hash a, { :b => { :bb => 33 }}
    refute_includes_hash a, { :b => { :bb => 22, :c => 3 }}
    refute_includes_hash a, { :a => 1, :c => { :dd => 44 }}
  end

end
