//
//  MainViewController.swift
//  GitFeed
//
//  Created by 김기현 on 2021/04/06.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ActivityController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    private let repo = "ReactiveX/RxSwift"
    private let disposeBag = DisposeBag()
    
    private let events = BehaviorRelay<[Event]>(value: [])
    private let lastModified = BehaviorRelay<String?>(value: nil)
    private let eventsFileURL = cachedFileURL("events.json")
    private let modifiedFileURL = cachedFileURL("modified.txt")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = repo
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
        refreshControl.tintColor = .darkGray
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.addSubview(refreshControl)
        
        /*
         디스크에 저장된 파일을 읽어오는 코드
         파일에서 객체를 한번만 읽어야 하므로 viewDidLoad()에서 수행
         저장된 이벤트가 있는 파일이 있는지 확인하고 해당 파일이 있는 경우 해당 내용을 이벤트에 로드
        */
        let decoder = JSONDecoder()
        if let eventsData = try? Data(contentsOf: eventsFileURL),
           let persistedEvents = try? decoder.decode([Event].self, from: eventsData) {
            events.accept(persistedEvents)
        }
        
        if let lastModifiedString = try? String(contentsOf: modifiedFileURL, encoding: .utf8) {
            lastModified.accept(lastModifiedString)
        }
        
        refresh()
    }
    
    @objc func refresh() {
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else { return }
            self.fetchEvents(repo: self.repo)
        }
    }

    func fetchEvents(repo: String) {
        // 가장 인기있는 레포를 가져오도록 URL 변경
        let response = Observable.from(["https://api.github.com/search/repositories?q=language:swift&per_page=5"])
            .map { urlString -> URL in
                return URL(string: urlString)!
            }
            .flatMap { url -> Observable<Any> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.json(request: request)
            }
            .flatMap { response -> Observable<String> in
                guard let response = response as? [String: Any],
                      let items = response["items"] as? [[String: Any]] else {
                    return Observable.empty()
                }
                
                return Observable.from(items.map { $0["full_name"] as! String })
            }
            .map { urlString -> URL in                                                      // String -> URL
                return URL(string: "https://api.github.com/repos/\(urlString)/events?per_page=10")!
            }
            .map { [weak self] url -> URLRequest in                                         // URL -> URLRequest
                var request = URLRequest(url: url)
                
                if let modifiedHeader = self?.lastModified.value {
                    request.addValue(modifiedHeader, forHTTPHeaderField: "Last-Modified")   // lastModified의 값이 nil이 아니면 해당 값을 헤더에 요청
                }
                
                return request
            }
            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in    // URLRequest -> Response
                return URLSession.shared.rx.response(request: request)                      // 요청을 서버로 보내고 응답을 받으면 반환된 데이터와 함께 .next 이벤트를 한번만 내보내고 완료
            }
            /*
             Observable을 공유하고 마지막으로 발생한 이벤트를 버퍼에 보관
             Observable이 완료되고 다시 구독하면 새 구독이 생성되고 서버에 또 다른 동일한 요청이 발생하는데 이러한 상황을 방지하기 위해 사용
             이 연산자는 방출된 마지막 아이템의 버퍼를 유지하고 새로 구독한 observer에게 제공
             따라서 요청이 완료되고 새 observer가 공유 시퀀스를 구독하면 이전에 실행된 네트워크 요청에서 버퍼링 된 응답을 즉시 수신
             
             share(relpay: scope:) 시용에 대한 경험적 규칙은 완료할 것으로 예상되는 시퀀스 또는 과도한 워크로드를 유발하고 여러번 구독하는 시퀀스에서 사용
            */
            .share(replay: 1)
        
        response
            .filter { response, _ in                                            // 200~299 상태 코드를 가진 응답만 통과
                return 200..<300 ~= response.statusCode                         // ~= -> 왼쪽의 범위에 오른쪽 값이 포함되어 있는지 확인
            }
            .map { _, data -> [Event] in                                        // Data -> [Event]
                let decoder = JSONDecoder()
                let events = try? decoder.decode([Event].self, from: data)
                return events ?? []
            }
            .filter { objects in                                                // 새 이벤트가 포함되지 않은 오류 응답 또는 응답이 삭제
                return !objects.isEmpty
            }
            .subscribe { [weak self] newEvents in
                self?.processEvents(newEvents)
            }
            .disposed(by: disposeBag)
        
        response
            .filter { response, _ in                                            // 현재 response의 statusCode가 200~399 사이인 경우만 필터링
                return 200..<400 ~= response.statusCode
            }
            .flatMap { response, _ -> Observable<String> in                     // 만약 response에 "Last-Modified"라는 헤더필드가 있으면 그 값을 리턴, 아니면 빈 Observable을 리턴
                guard let value = response.allHeaderFields["Last-Modified"] as? String else {
                    return Observable.empty()
                }
                
                return Observable.just(value)
            }
            .subscribe(onNext: { [weak self] modifiedHeader in
                guard let self = self else { return }
                
                self.lastModified.accept(modifiedHeader)
                
                // modifiedFileURL 에 받아온 modifiedHeader를 저장
                try? modifiedHeader.write(to: self.modifiedFileURL, atomically: true, encoding: .utf8)
            })
            .disposed(by: disposeBag)
    }
    
    func processEvents(_ newEvents: [Event]) {
        var updateEvents = newEvents + events.value
        
        if updateEvents.count > 50 {
            updateEvents = [Event](updateEvents.prefix(upTo: 50))
        }
        
        events.accept(updateEvents)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        
        let encoder = JSONEncoder()
        if let eventsData = try? encoder.encode(updateEvents) {                 // updateEvents를 Data객체로 인코딩 시도
            try? eventsData.write(to: eventsFileURL, options: .atomic)          // 결과 데이터로 write(to: options:)를 호출하고 파일을 만들거나 덮어쓸 파일의 URL을 제공
        }
    }
}

extension ActivityController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension ActivityController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ActivityTableViewCell else {
            return UITableViewCell()
        }
        
        let event = events.value[indexPath.row]
        
        cell.loginNameLabel.text = event.actor.name
        cell.descriptionLabel.text = event.repo.name + ", " + event.action.replacingOccurrences(of: "Event", with: "").lowercased()
        cell.contentImageView.kf.setImage(with: event.actor.avatar)
        
        return cell
    }
}

func cachedFileURL(_ fileName: String) -> URL {
    return FileManager.default
        .urls(for: .cachesDirectory, in: .allDomainsMask)
        .first!
        .appendingPathComponent(fileName)
}
