//
//  ItemsHandler.swift
//  Assignment
//
//  Created by Hari Krishna Bista on 12/15/16.
//  Copyright © 2016 meroApp. All rights reserved.
//

import UIKit

class MusicItemsHandler {
    var musicList:[MusicItem]?;
    let ITUNES_BASE_URL = "https://itunes.apple.com/search?term=";
    init() {
        self.musicList = [];
    }
    
    // calling api using differnet thread not to freeze the UI and tp improve performance
    func SearchMusic(searchText:String,completion: @escaping (_ finished:Bool) -> Void) {
        let url = self.ITUNES_BASE_URL + UtilitiesFunctions.removeWhiteSpaceByPlus(input: searchText);
        let request = URLRequest(url: URL(string: url)!);
        
        let configuration = URLSessionConfiguration.default;
        let urlSession = URLSession(configuration: configuration);
        
        OperationQueue().addOperation {
            let callApi = urlSession.dataTask(with: request) { (data, response, error) -> Void in
                
                do{
                    let items  = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary;
                    
                    
                    self.musicList?.removeAll();
                    
                    if let arrItems = items["results"] as? [NSDictionary] {
                        for item in arrItems {
                            
                            let musicItem = MusicItem();
                            
                            musicItem.trackName = item["trackName"] as? String;
                            musicItem.artistName = item["artistName"] as? String;
                            musicItem.collectionName = item["collectionName"] as? String;
                            let imgAlbum = item["artworkUrl100"] as? String;
                            musicItem.artworkUrl100 = URL(string: imgAlbum!);
                            
                            let trackViewUrl = item["trackViewUrl"] as? String;
                            musicItem.trackViewUrl = URL(string: trackViewUrl!);
                            
                            musicItem.trackPrice = item["trackPrice"] as? String;
                            
                            self.musicList?.append(musicItem);
                        }
                    }
                    
                    OperationQueue.main.addOperation({ () -> Void in
                        completion(true);
                    });

                } catch {
                    
                    print("parsing error");
                    
                    OperationQueue.main.addOperation({ () -> Void in
                        completion(false);
                    });
                }
            }
            
            callApi.resume();
        }
    }
}
