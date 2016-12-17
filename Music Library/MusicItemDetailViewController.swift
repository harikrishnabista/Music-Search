//
//  MusicItemDetailViewController.swift
//  Music Library
//
//  Created by Hari Krishna Bista on 12/17/16.
//  Copyright © 2016 meroApp. All rights reserved.
//

import UIKit


class MusicItemDetailViewController: UIViewController {

    @IBOutlet weak var lblCollectionName: UILabel!
    @IBOutlet weak var lblTrackName: UILabel!
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var txtLyrics: UITextView!
    
    var musicItem:MusicItem!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.txtLyrics.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
        self.txtLyrics.scrollRangeToVisible(NSMakeRange(0, 0));
        
        self.musicItem.getLyrics { (isParsed, lyricsItem: (url: String?, lyrics: String?)) in
            if(isParsed){
                self.txtLyrics.text = lyricsItem.lyrics;
            }
        }
        
        self.lblTrackName.text = self.musicItem.trackName;
        self.lblCollectionName.text = self.musicItem.collectionName;
        self.lblArtistName.text = self.musicItem.artistName;
        
//        self.textView.scrollRangeToVisible(NSMakeRange(0, 0))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
