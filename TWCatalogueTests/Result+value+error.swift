extension Result {
    var value: Success? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }

    var error: Error? {
        switch self {
        case .failure(let error):
            return error
        case .success:
            return nil
        }
    }
}
