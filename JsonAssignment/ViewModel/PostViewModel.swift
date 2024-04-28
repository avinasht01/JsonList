//
//  PostViewModel.swift
//  JsonAssignment
//
//  Created by Avinash Thakur on 26/04/24.
//

import Foundation

/** Enum to maintain state of pagination to check and fetch next list of posts
 - canFetchMoreItems: If there are more items to be fetched in next call
 - noMoreItemsToFetch: No more items to be fetched in next call  **/
enum PaginationState: Int {
    case canFetchMoreItems
    case noMoreItemsToFetch
}

/// Enum to maintain data fetching states while fetching list of post from  server
enum DataFetchingState: Int {
    /// idle: default state
    case idle
    /// fetchingData: fetching data either from cache or database
    case fetchingData
    /// fetchingDataViaPagination: fetching data from server via pagination
    case fetchingDataViaPagination
    /// failed: failed to fetch data from server or database
    case failed
    /// noData: In case there is no data available from cache or database
    case noData
    /// done: data fetching done from cache or database
    case done
}

/// PostViewModelDelegate function to update view controller to update UI for data fetching state, update data with result, fetching data via pagination.
protocol PostViewModelDelegate: NSObjectProtocol {
    func updateData()
    func updateViewForLoadingState()
    func updateViewForPaginationLoader()
    func noMoreDataCanBeFetched()
    func updateViewForApiFailure()
}

class PostViewModel: NSObject {
    private var pageNumber = 0
    weak var delegate: PostViewModelDelegate?
    
    var paginationState: PaginationState = .canFetchMoreItems
    
    /// dataFetchingState - Current data state is maintained using this instance, View controller confirming with PostViewModelDelegate, can be notified to update ui accordingly to display loading state, empty data state, data state.
    var dataFetchingState: DataFetchingState = .idle {
        didSet {
            switch dataFetchingState {
            case .idle:
                break
            case .fetchingData:
                self.delegate?.updateViewForLoadingState()
                break
            case .fetchingDataViaPagination:
                self.delegate?.updateViewForPaginationLoader()
                break
            case .failed:
                self.delegate?.updateViewForApiFailure()
            case .noData, .done:
                self.delegate?.updateData()
                break
            }
        }
    }
    
    /// allPostList holds all items fetched from server
    var allPostList = [Post]()
    
    /// list of 10 items passed sequentially to update UI
    var postList = [Post]()
    
    
    /// Function fetches list of posts from server
    func getListOfPostsFromServer() {
        self.dataFetchingState = .fetchingData
        PostService.fetchListOfPostFromServer { posts, error in
            if error == nil {
                self.allPostList = posts
                self.updateFirstPageList()
            } else {
                self.delegate?.updateViewForApiFailure()
            }
        }
    }
    
    /// Function sets list of first 10 post items, Added delay tof 2 seconds to simulate data fetching from center
    func updateFirstPageList() {
        for i in self.pageNumber..<PostConstants.pageLimit {
            self.postList.append(allPostList[i])
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.dataFetchingState = .done
        }
    }
    
    /// Function is notified by view controller when pos list is scrolled to bottom of list, In case if already dat fetching is in progress then call is discarded.
    func listScrolledToBottom(indexPath: IndexPath) {
        if dataFetchingState != .fetchingData && paginationState == .canFetchMoreItems {
            if indexPath.row == postList.count - 1 {
                self.delegate?.updateViewForPaginationLoader()
                dataFetchingState = .fetchingDataViaPagination
                getListOfPostAsPerPagination()
            }
        }
    }
    
    /// Function fetches data page wise till all posts are fetched from allPostList, Post from 10 -20, 20 -30 ,etc range till last post is fetched.
    private func getListOfPostAsPerPagination() {
        if postList.count % PostConstants.pageLimit == 0 {
            paginationState = .canFetchMoreItems
            pageNumber = postList.count
            let endRange = PostConstants.pageLimit + pageNumber
            print("going for next steps from:\(pageNumber) - to count: \(PostConstants.pageLimit + pageNumber)")
            
            if endRange <= allPostList.count {
                for i in pageNumber..<endRange {
                    postList.append(allPostList[i])
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.dataFetchingState = .done
                }
            } else {
                paginationState = .noMoreItemsToFetch
                self.delegate?.noMoreDataCanBeFetched()
            }
        } else {
            paginationState = .noMoreItemsToFetch
            self.delegate?.noMoreDataCanBeFetched()
        }
    }
    
}
