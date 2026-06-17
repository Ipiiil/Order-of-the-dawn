//
//  SwiftUISection.swift
//  CatGallery
//
//  Created by Полина Терехина on 20.02.2026.
//

import SwiftUI

struct SwiftUISection: View {
    let items: [ShopItem]
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.purple)
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(items, id: \.name) { item in
                        VStack {
                            Image(systemName: "photo.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                                .foregroundColor(.purple.opacity(0.7))
                                .background(Color.purple.opacity(0.1))
                                .cornerRadius(12)
                            
                            Text(item.name)
                                .font(.caption)
                                .lineLimit(1)
                            
                            Text("\(item.price) 💎")
                                .font(.caption2)
                                .foregroundColor(.purple)
                        }
                        .frame(width: 100)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 4)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
}


