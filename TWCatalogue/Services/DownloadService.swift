import Foundation
import RxSwift

enum DownloadError: Error {
    case foundation(Error)
    case internalTypeInconsistency
}

protocol DownloadServiceProtocol {
    func download(with request: URLRequest) -> Observable<Result<(HTTPURLResponse, Data?), DownloadError>>
}

class DownloadService: DownloadServiceProtocol {
    let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func download(with request: URLRequest) -> Observable<Result<(HTTPURLResponse, Data?), DownloadError>> {
        return Observable.create { [urlSession] observer in
            let dataTask = urlSession.dataTask(with: request) { data, response, error in
                if let error = error {
                    observer.onNext(.failure(.foundation(error)))
                    observer.onCompleted()
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    observer.onNext(.failure(.internalTypeInconsistency))
                    observer.onCompleted()
                    return
                }
                observer.onNext(.success((response, data)))
                observer.onCompleted()
            }

            dataTask.resume()
            return Disposables.create {
                dataTask.cancel()
            }
        }
    }
}
