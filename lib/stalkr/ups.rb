
class Array

    def to_perly_hash()
        h = {}
        self.each_index { |i|
            next if i % 2 != 0
            h[ self[i] ] = self[i+1]
        }
        return h
    end

end

module Stalkr

class UPS < Base

def track(id)

    url = "http://wwwapps.ups.com/WebTracking/processInputRequest?TypeOfInquiryNumber=T&loc=en_US&InquiryNumber1=%CODE%"

    url.gsub!(/%CODE%/, id)
    html = fetchurl(url)

    detail_scraper = Scraper.define do

        array :keys
        array :vals
        array :lists

        process "#trkNum", :trackingNumber => :text
        process "#tt_spStatus", :status => :text
        process "#fontControl dt", :keys => :text
        process "#fontControl dd", :vals => :text
        process "#fontControl ul.clearfix li", :lists => :text

        result :keys, :vals, :trackingNumber, :status, :lists

    end

    details = detail_scraper.scrape(html)

    if not details.trackingNumber then
        raise "UPS scraper failed"
    end

    ret = Result.new("UPS")

    if details.status.strip.downcase == "delivered" then
        ret.status = DELIVERED
    end

    hash = {}
    details.keys.each_with_index do |k,i|
        hash[k] = details.vals[i]
    end

    delivered_at = cleanup_html( hash["Delivered On:"] )
    ret.delivered_at = DateTime.strptime( delivered_at, "%A, %m/%d/%Y at %I:%M %p" ).to_time

    cleanup_html( details.lists[3] ) =~ /Updated: (.*?)$/
    ret.updated_at = DateTime.strptime( $1, "%m/%d/%Y %I:%M %p" ).to_time

    return ret

end

end # class UPS
end # module Stalkr
