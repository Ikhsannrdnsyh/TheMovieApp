//
//  AboutView.swift
//  TheMovieApp
//
//  Created by Mochamad Ikhsan Nurdiansyah on 04/03/25.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    profileImage
                    profileInfo
                    contactInfo
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

// MARK: - Components
extension AboutView {
    private var profileImage: some View {
        Image("PersonalPhoto")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .padding(.top, 20)
    }
    
    private var profileInfo: some View {
        VStack(spacing: 5) {
            Text("Mochamad Ikhsan Nurdiansyah")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("Developer | Design | Tech")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
    
    private var contactInfo: some View {
        VStack(alignment: .leading, spacing: 15) {
            SectionHeader(title: "Personal", icon: "link")
            Link("ikhsannurdiansyah.my.id", destination: URL(string: "http://ikhsannurdiansyah.my.id")!)
                .font(.body)
                .foregroundColor(.blue)
            
            SectionHeader(title: "Email", icon: "mail")
            Text("Ikhsannurdiansyah78@gmail.com")
                .font(.body)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
        }
        .padding(.top, 10)
    }
}

// MARK: - Preview
struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
