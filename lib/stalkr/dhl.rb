
module Stalkr

class DHL < Base

    # ########## (10 digit number)
    self.regex = /\b(\d{10})\b/i

    def track(id)

        url = "http://track.dhl-usa.com/TrackByNbr.asp?ShipmentNumber="
        html = fetchurl(url + id)

        begin

            info_scraper = Scraper.define do

                array :updated_at
                array :history

                process "td.headerRegular.pT5", :status => :text
                process "td.bodytext.pT5", :updated_at => :text
                process ".pL5_pT4_pB4_pR4", :history => :text

                result :status, :updated_at, :history
            end

            # row_scraper = Scraper.define do
            #     array :rows
            #     process "tr", :rows => td_scraper
            #     result :rows
            # end

            info = info_scraper.scrape(html)

            if not info.status or info.status.strip.empty? then
                raise "DHL scraper failed"
            end

            ret = Result.new(:DHL)

            status = cleanup_html(info.status).downcase
            if status =~ /delivered/ then
                ret.status = DELIVERED
            elsif info.history.size > 0 then
                ret.status = IN_TRANSIT
            else
                ret.status = UNKNOWN
            end

            updated_at = cleanup_html( info.updated_at.first )
            ret.updated_at = DateTime.strptime( updated_at, "Tracking detail provided by DHL: %m/%d/%Y, %I:%M:%S %p" ).to_time # 2/19/2011, 12:42:51 pm pt.

            if ret.status == DELIVERED then
                delivered_at = cleanup_html(info.history.shift)
                ret.delivered_at = DateTime.strptime( updated_at, "%m/%d/%Y %I:%M %p" ).to_time # 2/17/2011 10:13 am
            end

            # update location
            ret.location = cleanup_html(info.history[2])

            return ret

        rescue Exception => ex
            raise Stalkr::Error.new(ex, html)

        end

    end

end # class ChinaPost
end # module Stalkr

Stalkr.shippers << Stalkr::DHL
