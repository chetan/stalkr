
require 'json'
require 'yaml'

module Stalkr

class FEDEX < Base

    self.regex = /\b((96\d\d\d\d\d ?\d\d\d\d|96\d\d) ?\d\d\d\d ?d\d\d\d( ?\d\d\d)?)\b|\b(\d{12}|\d{15})\b/i

    def track(id)

        url = "http://www.fedex.com/Tracking?tracknumbers=%CODE%"

        url.gsub!(/%CODE%/, id)
        html = fetchurl(url)

        begin

            if html =~ /invalid._header/ then
                ret = Result.new(:FEDEX)
                ret.status = UNKNOWN
                return ret
            end

            info_scraper = Scraper.define do

                array :dates

                process "div.detailshipmentstatus", :status => :text
                process "div.detailshipdates > div.fielddata", :dates => :text
                process "div.detaildestination > div.fielddata", :destination => :text
                process_first "div.detailshipfacts div.dataentry", :service_type => :text

                result :status, :dates, :destination, :service_type

            end

            ret = Result.new(:FEDEX)

            info = info_scraper.scrape(html)

            if info.status.strip.downcase == "delivered" then
                ret.status = DELIVERED
            end
            ret.location = info.destination.strip

            # obj.service_type = info.service_type.strip

            # try to get dates
            shipped_date = info.dates[0].strip
            delivery_date = info.dates[1].strip if info.dates.length == 2
            if shipped_date.empty? then
                shipped_date = DateTime.strptime( $1, "%b %d, %Y" ).to_time if html =~ /var shipDate = "(.*?);$"/
                delivery_date = DateTime.strptime( "#{$1} -5", "%b %d, %Y %I:%M %p %z" ).to_time if html =~ /var deliveryDateTime = "(.*?)";$/
            end
            ret.delivered_at = delivery_date
            ret.updated_at = delivery_date

            return ret

        rescue Exception => ex
            raise Stalkr::Error.new(ex, html)

        end

    end

end # class FEDEX
end # module Stalkr
