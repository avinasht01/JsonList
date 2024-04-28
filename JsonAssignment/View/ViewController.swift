//
//  ViewController.swift
//  JsonAssignment
//
//  Created by Avinash Thakur on 26/04/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var postTableView: UITableView!
    var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: PostViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialiseView()
        registerTableViewCells()
        setActivityIndicator()
        fetchListOfPosts()
    }
    
    /// Function set activity indicator UI to be displayed while fetching pagination data.
    private func setActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
    }
    
    /// Function initialises PostViewModel
    private func initialiseView() {
        viewModel = PostViewModel()
        viewModel.delegate = self
    }
      
    /// Function fetches the list of post from server
    private func fetchListOfPosts() {
        viewModel.getListOfPostsFromServer()
    }
    
    /// Function registers table view cells for displaying initial loading state and post list.
    private func registerTableViewCells() {
        postTableView.register(UINib(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadingTableViewCell")
        postTableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        self.postTableView.estimatedRowHeight = 120
        self.postTableView.rowHeight = UITableView.automaticDimension
       
    }
    
    /// Function reloads table view, added delay to simulate server call behaviour.
    private func reloadTableViewContent() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.postTableView.reloadData()
        }
    }
    
    /// Function displays activity indicator when pagination call is started to fetch next list of items
    private func showPaginationActivityIndicator() {
        activityIndicator.startAnimating()
        self.view.bringSubviewToFront(activityIndicator)
    }
    
    /// Function stops displaying activity indicator when pagination call ends
    private func stopPaginationActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    /// Function displays failures alert in case fo api call failure
    private func showFailureAlert() {
        let alert = UIAlertController(title: PostConstants.alertTitle, message: PostConstants.alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: PostConstants.alertActionText, style: UIAlertAction.Style.default, handler: { _ in
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    /// Function loads Post Detail view controller
    private func loadPostDetails(post: Post) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        viewController.post = post
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}

//MARK: UITableViewDelegate functions

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.dataFetchingState == .fetchingData {
            return 20
        } else {
            return viewModel.postList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.dataFetchingState == .fetchingData {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell", for: indexPath) as? LoadingTableViewCell else {
                return UITableViewCell()
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell else {
                return UITableViewCell()
            }
            cell.updateCellContent(post: viewModel.postList[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.loadPostDetails(post: viewModel.postList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.dataFetchingState != .idle {
            viewModel.listScrolledToBottom(indexPath: indexPath)
        }
    }
}

//MARK: PostViewModelDelegate functions
extension ViewController: PostViewModelDelegate {
    
    func updateData() {
        self.reloadTableViewContent()
        stopPaginationActivityIndicator()
    }
    
    func updateViewForLoadingState() {
        self.reloadTableViewContent()
        stopPaginationActivityIndicator()
    }
    
    func updateViewForPaginationLoader() {
        showPaginationActivityIndicator()
    }
    
    func noMoreDataCanBeFetched() {
        stopPaginationActivityIndicator()
    }
    
    func updateViewForApiFailure() {
        showFailureAlert()
    }
    
    
}
