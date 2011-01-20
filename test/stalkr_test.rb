require File.dirname(__FILE__) + '/test_helper.rb'

class Stalkr_Test < Test::Unit::TestCase

    # useless test is useless :)
    def test_autoload_classes
        assert Stalkr::UPS
        assert Stalkr::USPS
        assert Stalkr::FEDEX
    end

    def test_unknown_shipper_code
        begin
            Stalkr.track("foobar")
            flunk("no exception was thrown")
        rescue => ex
            if ex.message != "Unknown shipper code" then
                flunk("wrong exception was thrown")
            end
        end
    end

end
