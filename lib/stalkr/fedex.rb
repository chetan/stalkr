
require 'json'
require 'yaml'

module Stalkr

class FEDEX < Base

    def track(id)

        url = "http://www.fedex.com/Tracking?tracknumbers=%CODE%"

        url.gsub!(/%CODE%/, id)
        html = fetchurl(url)

        info_scraper = Scraper.define do

            array :dates

            process "div.detailshipmentstatus", :status => :text
            process "div.detailshipdates > div.fielddata", :dates => :text
            process "div.detaildestination > div.fielddata", :destination => :text
            process_first "div.detailshipfacts div.dataentry", :service_type => :text

            result :status, :dates, :destination, :service_type

        end

        info = info_scraper.scrape(html)

        obj = OpenStruct.new(:shipper => 'FEDEX')
        obj.status = info.status.strip
        obj.shipped_to = info.destination.strip
        obj.service_type = info.service_type.strip

        obj.shipped_date = info.dates[0].strip
        obj.delivery_date = info.dates[1].strip if info.dates.length == 2

        # pull progress from JSON
        if html =~ /^var detailInfoObject = (.*);$/ then
            json = $1
            progress = JSON.parse(json)
            scans = progress['scans']

            progress = []

            scans.each { |scan|
                o = OpenStruct.new
                o.location      = scan['scanLocation']
                o.date          = scan['scanDate']
                o.local_time    = scan['scanTime']
                o.desc          = scan['scanStatus']
                progress << o
            }

            obj.progress = progress

        end

        return obj

    end

end # class FEDEX
end # module Stalkr
