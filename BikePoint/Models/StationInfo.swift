

class StationInfo {

    var addresses: [String]!
    
    var latitudes: [Double]!
    
    var longitudes: [Double]!
    
    var busyClots: [Int]!
    
    var freeSlots: [Int]!
    
    init(addresses: [String], latitudes: [Double], longitudes: [Double],
         busyClots: [Int], freeSlots: [Int]) {
        
        self.addresses = addresses
        self.latitudes = latitudes
        self.longitudes = longitudes
        self.busyClots = busyClots
        self.freeSlots = freeSlots
    }
}
