require File.dirname(__FILE__) + '/../test_helper.rb'

class DHL_Test < Test::Unit::TestCase

    def test_has_shipper
        assert(Stalkr.shippers.include? Stalkr::DHL)
    end

    def test_track
        id = "5391587692"
        info = Stalkr::DHL.new.track(id)
        assert(info.shipper == :DHL)
        assert(info.status == Stalkr::IN_TRANSIT)
        assert(info.updated_at.kind_of? Time)
    end

    def test_track_bad_code

        begin
            id = "foobar"
            info = Stalkr::DHL.new.track(id)
            flunk("no exception was thrown")

        rescue Exception => ex
            if ex.message != "DHL scraper failed" then
                flunk("wrong exception was thrown")
            end
        end

    end

    def test_valid_id
        id = "5391587692"
        assert(Stalkr::DHL.is_valid?(id))
    end

    def test_extract_id
        str = "*5391587692*"
        assert(Stalkr::DHL.extract_id(str) == "5391587692")
    end

end
