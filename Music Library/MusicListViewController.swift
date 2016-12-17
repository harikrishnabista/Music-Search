//
//  MusicListViewController.swift
//  Music Library
//
//  Created by Hari Krishna Bista on 12/16/16.
//  Copyright © 2016 meroApp. All rights reserved.
//

import UIKit

class MusicListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var itemsHandler = MusicItemsHandler();
    var urlSession:URLSession?
    
    var isAnimateNow = false;
    
    @IBOutlet weak var BottomTableView: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.searchBar.delegate = self;
        
        let configuration = URLSessionConfiguration.default;
        self.urlSession = URLSession(configuration: configuration);
        

        self.activityIndicator.stopAnimating();
        self.activityIndicator.isHidden = true;
        
        // registering event for keyboardwill show or hide
        NotificationCenter.default.addObserver(self, selector: #selector(MusicListViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(MusicListViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isAnimateNow = true;
    }
    
    func searchAndDisplay() {
        if let searchText = self.searchBar.text {
            
            self.activityIndicator.isHidden = false;
            self.activityIndicator.startAnimating();
            
            self.itemsHandler.SearchMusic(searchText: searchText) { (isParsed) in
                
                self.activityIndicator.stopAnimating();
                self.activityIndicator.isHidden = true;
                
                if(isParsed){
                    self.tableView.reloadData();
                }else{
                    print("error occured");
                }
            }
        }
    }
    
    @IBAction func btnRefreshTapped(_ sender: Any) {
        self.searchAndDisplay();
    }
    @IBOutlet weak var btnRefreshTapped: UIBarButtonItem!
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isAnimateNow = false;
    }
    
    // calculate the keyboard height as keyboard will show and add bottom constraint to shrink the uitableview height
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue;
        let keyboardRectangle = keyboardFrame.cgRectValue;
        let keyboardHeight = keyboardRectangle.height;
        self.BottomTableView.constant = keyboardHeight;
    }
    
    // expand the uitableview height as keyboard hides
    func keyboardWillHide(notification:NSNotification) {
        self.BottomTableView.constant = 0;
    }
    
    // uitableview delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.itemsHandler.musicList?.count)!;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData();
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicListTableViewCell", for: indexPath) as! MusicListTableViewCell;
        
        if let item = self.itemsHandler.musicList?[indexPath.row]{
            cell.lblTrackName.text = item.trackName;
            cell.lblArtistName.text = item.artistName;
            cell.lblCollectionName.text = item.collectionName;
            
            //            let start = NSDate();
            //            let end = NSDate();
            //            let timeInterval: Double = end.timeIntervalSince(start as Date);
            //            print("\(indexPath.row): \(timeInterval) seconds");
            
            cell.viewCellContainer.layer.cornerRadius = 4.0;
            cell.viewCellContainer.layer.borderColor = UIColor.lightGray.cgColor;
            cell.viewCellContainer.layer.borderWidth = 0.5;
            cell.viewCellContainer.backgroundColor = UIColor.white;
            
//             downloading the cell images from url and updating the UI asynchronously
            let request = URLRequest(url: item.artworkUrl100!);
            cell.imgDataTask = self.urlSession?.dataTask(with: request) { (data, response, error) -> Void in
                OperationQueue.main.addOperation({ () -> Void in
                    if error == nil && data != nil {
                        let image = UIImage(data: data!)
                        cell.imgView.image = image;
                    }else{
                        cell.imgView.image = UIImage(named:"no-image");
                    }
                });
            }
            cell.imgDataTask?.resume();
            
            // code to animate the uitableviewcell when user scrolls up and down otherwise do not animate
            if(isAnimateNow){
                let finalFrame = cell.viewCellContainer.frame;
                let initialFrame = CGRect(x: finalFrame.size.width/1.30, y: 0, width: finalFrame.size.width, height: finalFrame.size.height);
                
                cell.viewCellContainer.frame = initialFrame;
                cell.viewCellContainer.alpha = 0;
                UIView.animate(withDuration: 0.45, animations: {
                    cell.viewCellContainer.frame = finalFrame;
                    cell.viewCellContainer.alpha = 1;
                });
            }
            
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none;
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
//        let nextViewCon = storyBoard.instantiateViewController(withIdentifier: "FullImageViewController") as! FullImageViewController;
        
        if let cell = tableView.cellForRow(at: indexPath) as? MusicListTableViewCell {
            
            cell.viewCellContainer.backgroundColor = UIColor.lightGray;
            
//            nextViewCon.item = self.itemsHandler.filteredItems?[indexPath.row];
//            nextViewCon.item.itmImage = cell.imgView.image;
//            
//            self.navigationController?.pushViewController(nextViewCon, animated: true);
        }
    }
    
    // uisearchbar delegate methods
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = "";
        self.searchBar.resignFirstResponder();
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchAndDisplay();
        self.searchBar.resignFirstResponder();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
