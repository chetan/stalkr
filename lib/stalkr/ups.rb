
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

    self.regex = /\b(1Z ?[0-9A-Z]{3} ?[0-9A-Z]{3} ?[0-9A-Z]{2} ?[0-9A-Z]{4} ?[0-9A-Z]{3} ?[0-9A-Z]|[\dT]\d{3} ?\d{4} ?\d{3})\b/i

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

    ret = Result.new(:UPS)

    ret.status = case details.status.strip.downcase
        when "in transit"
            IN_TRANSIT
        when "delivered"
            DELIVERED
        else
            UNKNOWN
    end

    hash = {}
    details.keys.each_with_index do |k,i|
        hash[k] = details.vals[i]
    end

    if ret.status == DELIVERED then
        delivered_at = cleanup_html( hash["Delivered On:"] )
        ret.delivered_at = DateTime.strptime( delivered_at, "%A, %m/%d/%Y at %I:%M %p" ).to_time
    end

    cleanup_html( details.lists[3] ) =~ /Updated: (.*?)$/
    ret.updated_at = DateTime.strptime( $1, "%m/%d/%Y %I:%M %p" ).to_time

    return ret

end

end # class UPS
end # module Stalkr
