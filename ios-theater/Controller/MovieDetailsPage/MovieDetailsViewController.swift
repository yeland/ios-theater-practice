//
//  MovieDetailsViewController.swift
//  ios-theater
//
//  Created by Linxiao Wei on 2019/12/31.
//  Copyright © 2019 Linxiao Wei. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
  @IBOutlet weak var posterImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var originalTitleAndYear: UILabel!
  @IBOutlet weak var basicInfoLabel: UILabel!
  @IBOutlet weak var ratingView: RatingView!
  @IBOutlet weak var introductionLabel: IntroduceLabel!
  @IBOutlet weak var castsCollectionView: UICollectionView!
  
  private var movieDetailsViewModel: MovieDetailsViewModel!
  private var castCollectionViewDatasourse: CastCollectionViewDatasourse?
  private var castCollectionViewDelegate: CastCollectionViewDelegate?
  
  override func viewDidLoad() {
    navigationController?.navigationBar.isHidden = false
    let title = NSLocalizedString("movie", comment: "")
    self.title = title

    setupDatasourseAndDelegate()
    let movie = self.movieDetailsViewModel.movie
    guard let url = URL(string: movie.images.large) else { return }
    self.posterImage.setImage(withURL: url)
    self.posterImage.layer.cornerRadius = 5
    self.titleLabel.text = movie.title
    self.originalTitleAndYear.text = "\(self.movieDetailsViewModel.showedOriginalTitleAndYear)"
    let tap = UITapGestureRecognizer(target: self, action: #selector(clickToGetMoreInformation))
    basicInfoLabel.isUserInteractionEnabled = true
    basicInfoLabel.addGestureRecognizer(tap)
    
    ratingView.configure(movieDetailsViewModel)
    ratingView.layer.cornerRadius = 10
    fetchData()
  }
  
  func configure(withMovie movie: Movie) {
    movieDetailsViewModel = MovieDetailsViewModel(withMovie: movie)
  }
  
  func setupDatasourseAndDelegate() {
    castCollectionViewDatasourse = CastCollectionViewDatasourse(staffs: movieDetailsViewModel.castStaffs)
    let size = CGSize(width: 100, height: castsCollectionView.bounds.height)
    castCollectionViewDelegate = CastCollectionViewDelegate(size: size)
    castsCollectionView.dataSource = castCollectionViewDatasourse
    castsCollectionView.delegate = castCollectionViewDelegate
  }
  
  @objc func clickToGetMoreInformation() {
    let movieInfoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MovieInfoViewController") as MovieInfoViewController
    movieInfoViewController.configure(movieDetailViewModel: movieDetailsViewModel)
    present(movieInfoViewController, animated: true)
  }
  
  private func fetchData() {
    movieDetailsViewModel.fetchMovieDetails() {
      self.setupBasicInfo()
      self.ratingView.setRatingCount()
      self.introductionLabel.configure(withSummary: self.movieDetailsViewModel.movie.summary ?? "")
    }
  }
  
  private func setupBasicInfo() {
    let basicInfoString = NSMutableAttributedString(string: self.movieDetailsViewModel.showedBasicInformation)
    let rightAttachment = NSTextAttachment()
    rightAttachment.image = UIImage(systemName: "chevron.right")?.withTintColor(.darkGray)
    rightAttachment.bounds = CGRect(x: 0, y: -1, width: 8, height: 12)
    let rightString = NSAttributedString(attachment: rightAttachment)
    basicInfoString.append(rightString)
    self.basicInfoLabel.attributedText = basicInfoString
  }
}
