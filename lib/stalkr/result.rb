
module Stalkr

    UNKNOWN = :unknown
    DELIVERED = :delivered
    IN_TRANSIT = :in_transit

    class Result

        attr_accessor :shipper, :status, :updated_at, :delivered_at, :location

        def initialize(shipper)
            @shipper = shipper
        end

    end # class Result

end # module Stalkr
