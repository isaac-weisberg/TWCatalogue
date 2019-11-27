struct CatalogItem: Equatable {
    let id: Int
    let userId: Int
    let title: String
    let body: String

    init(dso model: CatalogItemDSO) {
        id = model.id
        userId = model.userId
        title = model.title
        body = model.body
    }

    init(dto model: CatalogItemDTO) {
        id = model.id
        userId = model.userId
        title = model.title
        body = model.body
    }
}
