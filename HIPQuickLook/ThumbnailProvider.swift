// ThumbnailProvider.swift
// HIP Quick Look Extension
//
// Generates Finder icon-view thumbnails for PNG-containing CIF files
// (type 2 — regular image, type 4 — OVL overlay).  Other CIF types and
// non-CIF files fall through so the system uses the default file icon.

import Quartz
import QuickLookThumbnailing

class ThumbnailProvider: QLThumbnailProvider {

    override func provideThumbnail(
        for request: QLFileThumbnailRequest,
        _ handler: @escaping (QLThumbnailReply?, Error?) -> Void
    ) {
        // Read the file
        guard let rawData = try? Data(contentsOf: request.fileURL),
              let hdr = parseCIFHeader(rawData),
              hdr.isImage                   // only type 2 (PNG) and type 4 (OVL)
        else {
            handler(nil, nil)
            return
        }

        let body = cifBody(rawData)
        guard !body.isEmpty else { handler(nil, nil); return }

        // Write the PNG body to a temp file and return it as the thumbnail
        let tmp = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString + ".png")
        do {
            try body.write(to: tmp)
            let reply = QLThumbnailReply(imageFileURL: tmp)
            handler(reply, nil)
        } catch {
            handler(nil, error)
        }
    }
}
