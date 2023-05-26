// MIT License
//
// Copyright (c) 2021 Sanity.io

import Foundation

public extension SanityClient {
    func fileURL(_ file: SanityType.File) -> SanityFileUrl {
        SanityFileUrl(file, projectId: self.config.projectId, dataset: self.config.dataset)
    }
}

extension URL {
    init(sanityFileUrl: SanityFileUrl) {
        guard let url = sanityFileUrl.URL() else {
            preconditionFailure("Could not construct url from SanityFileUrl id: \(sanityFileUrl.file.id)")
        }
        self = url
    }
}

public struct SanityFileUrl {
    public let file: SanityType.File
    private let projectId: String
    private let dataset: String

    init(_ file: SanityType.File, projectId: String, dataset: String) {
        self.file = file
        self.projectId = projectId
        self.dataset = dataset
    }

    public func URL() -> URL? {
        let filename = "\(file.id).\(file.extension)"
        let baseUrl = "/files/\(self.projectId)/\(self.dataset)/\(filename)"

        var components = URLComponents()
        components.scheme = "https"
        components.host = "cdn.sanity.io"
        components.path = baseUrl

        return components.url
    }
}
