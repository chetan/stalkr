
module Stalkr

class ChinaPost < Base

    # RA#########CN
    # not sure if the RA is constant or not
    self.regex = /\b(RA\d{9}CN)\b/i

    def track(id)

        url = "http://www.emsairmailtracking.com/chinapost.php"
        html = fetchurl(url, {"itemNo" => id})

        begin

            td_scraper = Scraper.define do
                array :tds
                process "td", :tds => :text
                result :tds
            end

            row_scraper = Scraper.define do
                array :rows
                process "tr", :rows => td_scraper
                result :rows
            end

            rows = row_scraper.scrape(html)

            if not rows or rows.size < 2 then
                raise "ChinaPost scraper failed"
            end

            ret = Result.new(:ChinaPost)

            # ["Item No.", "Year", "Status", "Location", "Destination Country", "Status", "Recipient's Signature"]
            # get rid of the header row
            rows.shift

            status = rows.first[2].strip.downcase
            puts status
            if status =~ /delivered/ then
                ret.status = DELIVERED
            elsif status =~ /arrival|departure/ then
                ret.status = IN_TRANSIT
            else
                ret.status = UNKNOWN
            end

            updated_at = cleanup_html( rows.first[5] )
            ret.updated_at = DateTime.strptime( updated_at, "%Y-%m-%d" ).to_time

            if ret.status == DELIVERED then
                ret.delivered_at = ret.updated_at
            end

            return ret

        rescue Exception => ex
            raise Stalkr::Error.new(ex, html)

        end

    end

end # class ChinaPost
end # module Stalkr
