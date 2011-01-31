
module Stalkr

class USPS < Base

    # 20 or 22 digits, beginning with 91 (and with or without spaces between groupings)
    self.regex = /\b(91\d{2} ?\d{4} ?\d{4} ?\d{4} ?\d{4} ?\d{2}|91\d{2} ?\d{4} ?\d{4} ?\d{4} ?\d{4})\b/i

    def track(id)

        # cleanup id
        id.gsub!(/ /, '')

        url = "http://trkcnfrm1.smi.usps.com/PTSInternetWeb/InterLabelInquiry.do?origTrackNum=%CODE%"

        url.gsub!(/%CODE%/, id)
        html = fetchurl(url)

        info_scraper = Scraper.define do

            array :details
            array :info

            process "span.mainTextbold", :info => :text
            process "td.mainTextbold", :details => :text
            process "td.mainText", :txt => :text

            result :details, :info, :txt

        end

        scrape = info_scraper.scrape(html)

        # verify its the correct response page
        if scrape.info[0].gsub(/ /, '') != id then
            raise "USPS scraper failed"
        end

        # extract and return
        ret = Result.new(:USPS)
        if scrape.txt =~ /There is no record of this item/ then
            ret.status = UNKNOWN
        elsif scrape.info[3].downcase == "delivered" then
            ret.status = DELIVERED
        else
            ret.status = UNKNOWN
        end

        if scrape.details and not scrape.details.empty? then
            if scrape.details[0] =~ /^(.*?), (.*? \d+, \d+), (\d+:\d+ .m), (.*?)$/ then
                ret.location = $4
                # not sure if this time is always in EST or the time of the area in which it was delivered?
                ret.updated_at = DateTime.strptime( "#{$2} #{$3} -0500", "%B %d, %Y %I:%M %p %z" ).to_time
                if ret.status == DELIVERED then
                    ret.delivered_at = ret.updated_at
                end

            elsif scrape.details[0] =~ /Electronic Shipping Info Received/ then
                ret.status = IN_TRANSIT
            end
        end

        return ret
    end

end # class USPS
end # module Stalkr
