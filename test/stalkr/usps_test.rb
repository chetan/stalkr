require File.dirname(__FILE__) + '/../test_helper.rb'

class USPS_Test < Test::Unit::TestCase

    def test_track
        id = "9102901001299192824023"
        info = Stalkr::USPS.new.track(id)
        assert(info.shipper == :USPS)
        assert(info.status == Stalkr::DELIVERED)
        assert(info.delivered_at.kind_of? Time)
    end

    def test_track_bad_code
        id = "9102901001312014825845"
        info = Stalkr::USPS.new.track(id)
        assert(info.shipper == :USPS)
        assert(info.status == Stalkr::UNKNOWN)
    end

    def test_extract_id
        str = "asdf 9102901001299192824023 asdfas"
        assert(Stalkr::USPS.extract_id(str) == "9102901001299192824023")
    end

end
