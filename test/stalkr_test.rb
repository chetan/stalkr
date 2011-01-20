require File.dirname(__FILE__) + '/test_helper.rb'

class Stalkr_Test < Test::Unit::TestCase

    # useless test is useless :)
    def test_autoload_classes
        assert Stalkr::UPS
        assert Stalkr::USPS
        assert Stalkr::FEDEX
    end

end
