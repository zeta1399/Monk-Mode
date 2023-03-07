//
//  StorePage.swift
//  Monk Mode
//
//  Created by Enver Enes Keskin on 7.03.2023.
//

import SwiftUI
import StoreKit

struct StorePage: View {
    @StateObject var storeKit = StoreKitManager()
    var body: some View {
        VStack(alignment: .leading) {
                    Text("In-App Purchase Demo")
                        .bold()
                    Divider()
                    ForEach(storeKit.storeProducts) {product in
                        HStack {
                            Text(product.displayName)
                            Spacer()
                            Button(action: {
                                // purchase this product
                                Task { try await storeKit.purchase(product)
                                }
                            }) {
                                CourseItem(storeKit: storeKit, product: product)
                                  
                            }
                        }
                        
                    }
                    Divider()
                    Button("Restore Purchases", action: {
                        Task {
                            //This call displays a system prompt that asks users to authenticate with their App Store credentials.
                            //Call this function only in response to an explicit user action, such as tapping a button.
                            try? await AppStore.sync()
                        }
                    })
                }
                .padding()
    }
}

struct CourseItem: View {
    @ObservedObject var storeKit : StoreKitManager
    @State var isPurchased: Bool = false
    var product: Product
    
    var body: some View {
        VStack {
            if isPurchased {
                Text(Image(systemName: "checkmark"))
                    .bold()
                    .padding(10)
            } else {
                Text(product.displayPrice)
                    .padding(10)
            }
        }
        .onChange(of: storeKit.purchasedCourses) { course in
            Task {
                isPurchased = (try? await storeKit.isPurchased(product)) ?? false
            }
        }
    }
}

struct StorePage_Previews: PreviewProvider {
    static var previews: some View {
        StorePage()
    }
}
