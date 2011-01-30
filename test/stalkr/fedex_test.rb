require File.dirname(__FILE__) + '/../test_helper.rb'

class FEDEX_Test < Test::Unit::TestCase

    def test_track
        id = "106050761498748"
        info = Stalkr::FEDEX.new.track(id)
        assert(info.shipper == :FEDEX)
        assert(info.status == Stalkr::DELIVERED)
        assert(info.delivered_at.kind_of? Time)
    end

    def test_track_bad_code

        id = "foobar"
        info = Stalkr::FEDEX.new.track(id)
        assert(info.status == Stalkr::UNKNOWN)

    end

end
