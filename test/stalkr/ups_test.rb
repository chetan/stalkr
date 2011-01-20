require File.dirname(__FILE__) + '/../test_helper.rb'

class Stalkr_Test < Test::Unit::TestCase

    # useless test is useless :)
    def test_track

        id = "1ZX799470341200708"
        info = Stalkr::UPS.new.track(id)
        assert(info.shipper == :UPS)
        assert(info.status == Stalkr::DELIVERED)
        assert(info.delivered_at.kind_of? Time)
    end

    def test_track_bad_code

        begin
            id = "foobar"
            info = Stalkr::UPS.new.track(id)
            flunk("no exception was thrown")
        rescue => ex
            if ex.message != "UPS scraper failed" then
                flunk("wrong exception was thrown")
            end
        end

    end

end
