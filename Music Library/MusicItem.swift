//
//  Item.swift
//  Assignment
//
//  Created by Hari Krishna Bista on 12/15/16.
//  Copyright © 2016 meroApp. All rights reserved.
//

import UIKit

class MusicItem {
    
    var artistName:String?
    var collectionName:String?
    var trackName:String?
    var artworkUrl100:URL?
    var trackPrice:String?
    var trackViewUrl:URL?
    
    private func getFormattedUrlFor() -> URL? {
        
        if let artistName = self.artistName, let trackName = self.trackName  {
            let urlStr = "http://lyrics.wikia.com/api.php?func=getSong&artist=\(UtilitiesFunctions.removeWhiteSpaceByPlus(input: artistName))&song=\(UtilitiesFunctions.removeWhiteSpaceByPlus(input: trackName))&fmt=json";
            
            if let url = URL(string: urlStr) {
                return url;
            }
        }
        
        return nil;
    }
    
    func getLyrics(completion: @escaping (_ finished:Bool,(url:String?, lyrics:String?)) -> Void) {
        
        if let url = self.getFormattedUrlFor(){
            
            let request = URLRequest(url: url);
            
            let configuration = URLSessionConfiguration.default;
            let urlSession = URLSession(configuration: configuration);
            
            OperationQueue().addOperation {
                let callApi = urlSession.dataTask(with: request) { (data, response, error) -> Void in
                    
                    guard error == nil && data != nil else{
                        OperationQueue.main.addOperation {
                            completion(true, (url: "", lyrics: "Not found"))
                        }
                        return;
                    }
                    
                    var dataString = String(data: data!, encoding: .utf8)!;
                    
                    guard dataString.contains("song =") else{
                        OperationQueue.main.addOperation {
                            completion(true, (url: "", lyrics: "Not found"))
                        }
                        return;
                    }
                    
                    do{
                        dataString = UtilitiesFunctions.stringByReplacingFirstOccurrenceOfString(target: dataString, byStr:"song =", withStr: "");
                        
                        dataString = dataString.replacingOccurrences(of: "'", with: "\"");
                        dataString = dataString.trimmingCharacters(in: .whitespaces);
                        dataString = dataString.trimmingCharacters(in: .newlines);
                        
                        if let jsnData  = dataString.data(using: .utf8){
                            let jsnLyrics  = try JSONSerialization.jsonObject(with: jsnData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary;
                            
                            let lyrics = jsnLyrics["lyrics"] as? String;
                            let url = jsnLyrics["url"] as? String;
                            
                            OperationQueue.main.addOperation {
                                completion(true, (url: url, lyrics: lyrics))
                            }
                        }
                        
                    } catch {
                        OperationQueue.main.addOperation {
                            completion(true, (url: "", lyrics: "Not found"))
                        }
                        print("parsing error");
                    }
                }
                
                callApi.resume();
            }
        }
    }
}
