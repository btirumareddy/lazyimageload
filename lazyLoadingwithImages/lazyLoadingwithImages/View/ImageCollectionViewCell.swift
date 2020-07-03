//
//  ImageCollectionViewCell.swift
//  lazyLoadingwithImages
//
//  Created by Bhanuja Tirumareddy on 02/07/20.
//  Copyright © 2020 Bhanuja Tirumareddy. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var previewImageView: UIImageView!
    
    func configure(track: GetDataModel) {
            
            dateLabel.text = getDateFrom(track.dateTime)
            timeLabel.text = getTimeFrom(track.dateTime)
            sizeLabel.text = track.size
            
            switch track.status {
            case "STATUS_NONE":
                statusImageView.image = UIImage.init(named: "STATUS_NONE.png")
            case "STATUS_DOWNLOADED":
                statusImageView.image = UIImage.init(named: "STATUS_DOWNLOADED.png")
            case "STATUS_UPLOADED":
                statusImageView.image = UIImage.init(named: "STATUS_UPLOADED.png")
            default:
                statusImageView.image = UIImage.init(named: "STATUS_NONE.png")
            }
            let imageUrl = track.thumbnail
           getData(from: imageUrl) { data, response, error in
               guard let data = data, error == nil else { return }
               print(response?.suggestedFilename ?? imageUrl.lastPathComponent)
               DispatchQueue.main.async() { [weak self] in
                self?.previewImageView.image = UIImage(data: data)
               }
           }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
        func getTimeFrom(_ str: String) -> String {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = formatter.date(from: str) {
                formatter.dateFormat = "hh:mm:ss a"
                let timeStr = formatter.string(from: date)
                print(timeStr) //add timeStr to your timeLabel here...
                return  timeStr
                
            }
            else {
                return ""
            }
            
        }
        func getDateFrom(_ str: String) -> String {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = formatter.date(from: str) {
                formatter.dateFormat = "yyyy-MM-dd"
                let dateStr = formatter.string(from: date)
                print(dateStr) //add dateStr to your dateLabel here...
                return dateStr
            }
            else {
                return ""
            }
        }
}
