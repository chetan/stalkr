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

    def test_track_bad_code_numeric

        begin
            id = "200793242831442"
            info = Stalkr::FEDEX.new.track(id)
            flunk("no exception raised")

        rescue Exception => ex
            assert(ex.kind_of? Stalkr::Error)
            assert(!(ex.html.nil? || ex.html.empty?))
        end

    end

    def test_extract_id
        str = "asdf 106050761498748 asdfas"
        assert(Stalkr::FEDEX.extract_id(str) == "106050761498748")
    end

    def test_should_not_extract
        str = "Your tracking number is: 02185456301085740874. "
        id = Stalkr::FEDEX.extract_id(str)
        assert(id.nil?)
    end

end
