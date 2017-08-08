
class ParkingInfo {
    
    var address: String!
    
    var latitude: Double!
    
    var longitude: Double!
    
    var busySlot: Int!
    
    var freeSlot: Int!
    
    var distanse: Float?
    
    init (adress: String!, latitude: Double!, longitude: Double!, busySlot: Int!, freeSlot: Int!) {
    
        self.address = adress
        self.latitude = latitude
        self.longitude = longitude
        self.busySlot = busySlot
        self.freeSlot = freeSlot
    }
}

class StationsInfo {

    var parkingInfo: [ParkingInfo] = []
    
    init(addresses: [String], latitudes: [Double], longitudes: [Double], busyClots: [Int], freeSlots: [Int]) {
        
        for number in  0 ... ((addresses.count) - 1) {
        
            let parkingInfo = ParkingInfo(adress: addresses[number], latitude: latitudes[number],
                                                  longitude: longitudes[number], busySlot: busyClots[number],
                                                  freeSlot: freeSlots[number])
            
            self.parkingInfo.append(parkingInfo)
        }
    }
}


