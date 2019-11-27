import Foundation
import RxSwift

enum DownloadError: Error {
    case foundation(Error)
    case internalTypeInconsistency
}

protocol DownloadServiceProtocol {
    func download(with request: URLRequest) -> Single<Result<(HTTPURLResponse, Data?), DownloadError>>
}

class DownloadService: DownloadServiceProtocol {
    let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func download(with request: URLRequest) -> Single<Result<(HTTPURLResponse, Data?), DownloadError>> {
        return Single.create { [urlSession] observer in
            let dataTask = urlSession.dataTask(with: request) { data, response, error in
                if let error = error {
                    observer(.success(.failure(.foundation(error))))
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    observer(.success(.failure(.internalTypeInconsistency)))
                    return
                }
                observer(.success(.success((response, data))))
            }

            dataTask.resume()
            return Disposables.create {
                dataTask.cancel()
            }
        }
    }
}
