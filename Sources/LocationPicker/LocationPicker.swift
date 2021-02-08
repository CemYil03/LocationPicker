import SwiftUI
import MapKit

struct IdentifiableMapItem: Identifiable {
    let id: UUID = UUID()
    let mapItem: MKMapItem
}

@available(iOS 13.0, *)
public class LocationPicker: NSObject, MKLocalSearchCompleterDelegate, ObservableObject {
    
    @Published var searchResults: [MKLocalSearchCompletion]? = []
    @Published var isSearching: Bool = false
    @Published var mapItems: [IdentifiableMapItem] = []
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 38.13471, longitude: 11.365323),
        span: MKCoordinateSpan(latitudeDelta: 64, longitudeDelta: 64)
    )
    
    private let localSearchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()
    
    init(searchRegion: MKCoordinateRegion? = nil) {
        super.init()
        self.localSearchCompleter.delegate = self
//        self.localSearchCompleter.pointOfInterestFilter = MKPointOfInterestFilter.excludingAll
        if let searchRegion = searchRegion {
            self.localSearchCompleter.region = searchRegion
        }
        
    }
    
    public func enterSearchText(searchText: String) {
        if searchText == "" {
            self.searchResults = []
        } else {
            self.localSearchCompleter.queryFragment = searchText
            self.isSearching = self.localSearchCompleter.isSearching
        }
    }
    
    public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchResults = completer.results
        self.isSearching = self.localSearchCompleter.isSearching
    }
    
    public func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.searchResults = nil
        self.isSearching = self.localSearchCompleter.isSearching
    }
    
    public func getLocationsFor(searchComletion: MKLocalSearchCompletion, completion: @escaping (_ perfectMatch: MKMapItem?) -> Void) {
        
        let localSearchRequest = MKLocalSearch.Request(completion: searchComletion)
        let localSearch = MKLocalSearch(request: localSearchRequest)
        
        localSearch.start { response, error in
            
            if let response = response {
                
                if response.mapItems.count == 1 {
                    completion(response.mapItems.first!)
                } else {
                    self.mapItems = response.mapItems.map { IdentifiableMapItem(mapItem: $0) }
                    withAnimation {
                        self.mapRegion = response.boundingRegion
                    }
                }
            
            }
            
        }
        
    }
    
}
