//
//  TagView.swift
//  ChipsViewApp
//
//  Created by Bilal Durnagöl on 4.06.2023.
//

import SwiftUI


struct TagView: View {
    var maxLimit: Int
    @Binding var tags: [Tag]
    var title = "Add Some Tags"
    var fontSize: CGFloat = 16
    // adding geometry effect of tag
    @Namespace var animation
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15) {
            
            Text(title)
                .font(.callout)
                .foregroundColor(Color("Tag"))
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    
                    // Displaying tags
                    ForEach(getRows(), id: \.self) { rows in
                        HStack(spacing: 6) {
                            ForEach(rows) { row in
                                // row view
                                RowView(tag: row)
                            }
                        }
                    }
                    
                }
                .frame(width: UIScreen.main.bounds.width - 80, alignment: .leading)
                .padding(.vertical)
                .padding(.bottom, 2)
            }
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color("Tag").opacity(0.15), lineWidth: 1)
            }
            // animating
            .animation(.easeOut, value: tags)
            .overlay(alignment: .bottomTrailing, content: {
                Text("\(getSize(tags: tags))/\(maxLimit)")
                    .foregroundColor(Color("Tag"))
                    .font(.system(size: 13, weight: .semibold))
                    .padding(12)
            })
        }
        // since onchange will perform little late...
//        .onChange(of: tags) { newValue in
//
//        }
    }
    
    @ViewBuilder
    func RowView(tag: Tag) -> some View {
        Text(tag.text)
            .font(.system(size: fontSize))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background {
                Capsule()
                    .fill(Color("Tag"))
                
            }
            .foregroundColor(Color("BG"))
            .lineLimit(1)
        //delete
            .contentShape(Capsule())
            .contextMenu {
                Button("Delete") {
                    tags.remove(at: getIndex(tag: tag))
                }
            }
            .matchedGeometryEffect(id: tag.id, in: animation)
    }
    
    func getIndex(tag: Tag) -> Int {
        let index = tags.firstIndex { currentTag in
            return tag.id == currentTag.id
        } ?? 0
        
        return index
    }
    
    // Basic logic
    // Splintting the array when it exceeds the screen size
    func getRows() -> [[Tag]] {
        var rows: [[Tag]] = []
        var currentRow: [Tag] = []
        
        let screenWidth: CGFloat = UIScreen.main.bounds.width - 80
        var totalWidth: CGFloat = 0
        
        tags.forEach { tag in
            // addding the capsule size into total widht with spacing
            // 14 + 14 + 6 + 6
            // extra 6 for safety
            totalWidth += (tag.size + 40)
            
            if totalWidth > screenWidth {
                // adding row in rows
                // clearing the data
                // checking for long string
                
                totalWidth = (!currentRow.isEmpty || rows.isEmpty ? (tag.size + 40) : 0)
                
                rows.append(currentRow)
                currentRow.removeAll()
                currentRow.append(tag)
            } else {
                currentRow.append(tag)
            }
        }
        
        // safe check
        // if having any value storing it in rows
        
        if !currentRow.isEmpty {
            rows.append(currentRow)
            currentRow.removeAll()
        }
        
        return rows
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Global function
func addTag(tags: [Tag], text: String, fontSize: CGFloat, maxLimit: Int, completion: @escaping (Bool, Tag) -> ()) {
    
    let font = UIFont.systemFont(ofSize: fontSize)
    
    let attributes = [NSAttributedString.Key.font: font]
    let size = (text as NSString).size(withAttributes: attributes)
    
    
    let tag = Tag(text: text, size: size.width)
    
    if (getSize(tags: tags) + text.count) < maxLimit {
        completion(false, tag)
    } else {
        completion(true, tag)
    }
}

func getSize(tags: [Tag]) -> Int {
    var count: Int = 0
    
    tags.forEach { tag in
        count += tag.text.count
    }
    
    return count
}
