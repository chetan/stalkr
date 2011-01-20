
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

        array :details
        process "td.det-pad", :details => :text

        result :details

    end

    details_raw = detail_scraper.scrape(html)

    details = []
    details_raw.each { |d|
        d.strip!
        next if d == '&nbsp;' || d.empty?
        details << cleanup_html(d)
    }

    obj = OpenStruct.new(:shipper => 'UPS')

    if details[0] !~ /:$/ and details.length % 2 == 1 then
        obj.info = details.shift # first line has some basic info
    end

    h = details.to_perly_hash()

    obj.type            = h['Type:']
    obj.status          = h['Status:']
    obj.service         = h['Service:']
    obj.tracking_num    = h['Tracking Number:']
    obj.weight          = h['Weight:']

    if obj.status =~ /\n/ then
        # can have multiline status until it's delivered
        obj.status = obj.status.split(/\n/)[0]
    end

    if obj.status.downcase == 'delivered' then
        obj.shipped_to      = h['Delivered To:']
        obj.delivery_date   = h['Delivered On:'].split.join(' ')
    else
        obj.delivery_date   = h['Rescheduled Delivery:']
        obj.shipped_date    = h['Shipped/Billed On:']
        obj.shipped_to      = h['Shipped To:']
    end

    progress_scraper = Scraper.define do
        array :progress
        process "td.sec-pad", :progress => :text
        result :progress
    end

    progress_raw = progress_scraper.scrape(html)

    progress = []

    progress_raw.each_index { |i|
        next if i % 4 != 0 or i == 0
        o = OpenStruct.new
        o.location      = cleanup_html(progress_raw[i]).gsub(/\n/, ' ')
        o.date          = cleanup_html(progress_raw[i+1])
        o.local_time    = cleanup_html(progress_raw[i+2])
        o.desc          = cleanup_html(progress_raw[i+3])
        progress << o
    }

    obj.progress = progress

    return obj

end

end # class UPS
end # module Stalkr
