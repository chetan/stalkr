require File.dirname(__FILE__) + '/../test_helper.rb'

class UPS_Test < Test::Unit::TestCase

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

    def test_valid_id
        id = "1ZX799470341200708"
        ret = Stalkr::UPS.is_valid?(id)
        assert(ret)
    end

    def test_invalid_id
        id = "1X799470341200708"
        ret = Stalkr::UPS.is_valid?(id)
        assert(!ret)
    end

    def test_extract_id
        str = "asdf 1ZX799470341200708 asdfas"
        assert(Stalkr::UPS.extract_id(str) == "1ZX799470341200708")
    end

end
