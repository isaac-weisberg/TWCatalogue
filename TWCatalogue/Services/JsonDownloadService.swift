import RxSwift
import Foundation

enum JsonDownloadError: Error {
    case parsing(Error)
    case noData
    case badStatusCode(Int)
    case download(DownloadError)
}

protocol JsonDownloadServiceProtocol {
    func download<Model: Decodable>(from url: URL) -> Single<Result<Model, JsonDownloadError>>
}

class JsonDownloadService: JsonDownloadServiceProtocol {
    let downloadService: DownloadServiceProtocol

    init(downloadService: DownloadServiceProtocol) {
        self.downloadService = downloadService
    }

    func download<Model: Decodable>(from url: URL) -> Single<Result<Model, JsonDownloadError>> {
        let request = URLRequest(url: url)

        return downloadService.download(with: request)
            .map { result in
                result
                    .mapError { error in
                        JsonDownloadError.download(error)
                    }
                    .flatMap { response, data -> Result<Model, JsonDownloadError> in
                        guard response.statusCode == 200 else {
                            return .failure(.badStatusCode(response.statusCode))
                        }
                        guard let data = data else {
                            return .failure(.noData)
                        }
                        let model: Model
                        do {
                            model = try JSONDecoder().decode(Model.self, from: data)
                        } catch {
                            return .failure(.parsing(error))
                        }
                        return .success(model)
                    }
            }
    }
}
