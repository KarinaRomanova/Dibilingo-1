//
//  UserProfile_ViewModel.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 06.12.2020.
//

import Foundation
import UIKit
import SwiftUI

class UserProfile_ViewModel: ObservableObject {
    @Published var profile: UserProfile? 
    @Published var needSaving: Bool = false
    
    init() {
        //self.profile = UserProfile_ViewModel.getUserProfile()
    }
    
    func updateUserProfile() {
        self.profile = UserProfile_ViewModel.getUserProfile()
    }
    
    func mainmenuLoad() {
        if profile == nil {
            self.profile = UserProfile_ViewModel.getUserProfile()
        }
    }
    
    func _loadFromServer() {
        
    }
    
    func levelExit() {
        if needSaving {
            _SaveAndUpload()
        }
        needSaving = false
    }
    
    func _SaveAndUpload() {
        guard var up = self.profile else { fatalError("Profile is nil") }
        
        ///
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date = Date()
        up.lastUpdated = dateFormatter.string(from: date)
        
        // Saving to file
        DispatchQueue.global(qos: .userInitiated).async {
            UserProfile_ViewModel.saveUserProfile(up)
        }
        
        let url = URL(string: "\(serverURL)/dibilingo/api/v1.0/userupdate/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = try? JSONEncoder().encode(up)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        struct callback: Codable {
            let result: String
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else { return }
            guard let data = data else { return }
            
            if let decoded = try? JSONDecoder().decode(callback.self, from: data) {
                print("upload result: \(decoded.result)")
            }
        }
        .resume()
    }
    
    static func getUserProfile() -> UserProfile? {
        let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        if let up_data = try? Data(contentsOf: baseURL.appendingPathComponent("UserProfile")) {
            if let up_decoded = try? JSONDecoder().decode(UserProfile.self, from: up_data) {
                return up_decoded
            }
        }
        return nil
    }

    static func saveUserProfile(_ up: UserProfile) {
        let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        if let encoded = try? JSONEncoder().encode(up) {
            try? encoded.write(to: baseURL.appendingPathComponent("UserProfile"), options: .atomic)
        }
    }
}
