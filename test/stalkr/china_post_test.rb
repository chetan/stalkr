require File.dirname(__FILE__) + '/../test_helper.rb'

class ChinaPost_Test < Test::Unit::TestCase

    def test_track
        id = "RA103044224CN"
        info = Stalkr::ChinaPost.new.track(id)
        assert(info.shipper == :ChinaPost)
        assert(info.status == Stalkr::IN_TRANSIT)
        assert(info.updated_at.kind_of? Time)
    end

    def test_track_bad_code

        begin
            id = "foobar"
            info = Stalkr::ChinaPost.new.track(id)
            flunk("no exception was thrown")
        rescue Exception => ex
            if ex.message != "ChinaPost scraper failed" then
                flunk("wrong exception was thrown")
            end
        end

    end

    def test_valid_id
        id = "RA103044224CN"
        ret = Stalkr::ChinaPost.is_valid?(id)
        assert(ret)
    end

    def test_invalid_id
        id = "1X799470341200708"
        ret = Stalkr::ChinaPost.is_valid?(id)
        assert(!ret)
    end

    def test_extract_id
        str = "asdf RA103044224CN asdf"
        assert(Stalkr::ChinaPost.extract_id(str) == "RA103044224CN")
    end

end
