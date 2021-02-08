import SwiftUI
import MapKit

@available(iOS 14.0, *)
public struct LocationPickerView: View {
    
    @Binding public var coordinates: CLLocationCoordinate2D?
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var searchText: String = ""
    @StateObject private var localSearchCompleter: LocationPicker = LocationPicker()
    
    public init(coordinates: Binding<CLLocationCoordinate2D?>) {
        self._coordinates = coordinates
    }
    
    public var body: some View {
        
        ZStack {
            
            
            
            // MARK: Map
            
            Map(coordinateRegion: self.$localSearchCompleter.mapRegion, annotationItems: self.localSearchCompleter.mapItems) { result in

                MapAnnotation(coordinate: result.mapItem.placemark.coordinate) {

                    VStack(spacing: 4) {
                        
                        Image(systemName: "mappin.and.ellipse")
                            .padding(10)
                            .background(Color.red)
                            .foregroundColor(Color.white)
                            .clipShape(Circle())
                        
                        Circle().frame(width: 6, height: 6)
                            .foregroundColor(Color.red)
                        
                    }
                    .shadow(radius: 4)
                    .onTapGesture {
                        self.coordinates = result.mapItem.placemark.coordinate
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                }

            }.ignoresSafeArea()
            
            
            
            // MARK: Search
            
            VStack {
                
                HStack {
                    
                    TextField("", text: self.$searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: self.searchText) { newValue in
                            self.localSearchCompleter.enterSearchText(searchText: newValue)
                        }
                    
                    if self.localSearchCompleter.isSearching {
                        ProgressView()
                            .frame(width: 34, height: 34)
                            .padding(.leading)
                    } else {
                        
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: 34, height: 34)
                                .foregroundColor(Color(UIColor.systemBackground))
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color.blue)
                            
                        }.padding(.leading)
                        
                    }
                    
                }.padding()
                
                
                
                // MARK: Suggestions
                
                if let searchResults = self.localSearchCompleter.searchResults {
    
                    if searchResults.count > 0 {
                        List {
                            ForEach(searchResults, id: \.self) { searchresult in
                                Button(
                                    action: {
                                        self.localSearchCompleter.getLocationsFor(searchComletion: searchresult) { perfectMatch in
                                            if let mapItem = perfectMatch {
                                                self.coordinates = mapItem.placemark.coordinate
                                                self.presentationMode.wrappedValue.dismiss()
                                            }
                                        }
                                        self.searchText = ""
                                    },
                                    label: {
                                        VStack(alignment: HorizontalAlignment.leading) {
                                            Text(searchresult.title)
                                            
                                            if searchresult.subtitle != "" {
                                                Text(searchresult.subtitle)
                                                    .font(Font.footnote)
                                                    .lineLimit(1)
                                            }
                                        }
                                    }
                                )
                            }
                        }.frame(height: UIScreen.main.bounds.height / 3)
                        
                        .cornerRadius(8)
                        .padding(.bottom).padding(.bottom)
                        .padding(.horizontal)
                        
                    }
    
                } else {
                    Text("Suche fehlgeschlagen")
                }
                
                Spacer()
                
            }
            
        }.navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
        .navigationBarTitle("Standort auswählen")
        
    }
    
}
