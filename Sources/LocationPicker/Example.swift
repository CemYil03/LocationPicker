import SwiftUI
import MapKit

@available(iOS 14.0, *)
private struct RequiringView: View {
    
    @State private var coordinates: CLLocationCoordinate2D? = nil
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                NavigationLink("Get Coordinates", destination: LocationPickerView(coordinates: self.$coordinates))
                
                if let coordinates = self.coordinates {
                    Text("Längengrad: \(coordinates.latitude)")
                    Text("Breitengrad: \(coordinates.longitude)")
                }
            }
            
        }
        
    }
    
}



@available(iOS 14.0, *)
struct RequiringView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        RequiringView()
        
    }
    
}
