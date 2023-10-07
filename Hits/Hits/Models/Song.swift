//
//  Song.swift
//  Hits
//
//  Created by Romain Le Drogo on 07/10/2023.
//

import Foundation

struct Song: Decodable, Identifiable {
    
    let id: Int
    let title: String
    let preview: String
    
    let album: Album
    
    init?(id: Int?, title: String?, preview: String?,
          album: Album?) {
        guard let id = id, let title = title, let preview = preview, let album = album else {return nil}

        self.id = id
        self.title = title
        self.preview = preview
        
        self.album = album
    }
}

struct Album: Decodable {
    
    let id: Int
    let title: String
    let cover: String

    init?(id: Int?, title: String?, cover: String?) {
        guard let id = id, let title = title, let cover = cover else {return nil}

        self.id = id
        self.title = title
        self.cover = cover
    }

}

// MARK: Data Sample
//{
//  "id": 77698470,
//  "readable": true,
//  "title": "Magic in the Air (feat. Ahmed Chawki)",
//  "title_short": "Magic in the Air (feat. Ahmed Chawki)",
//  "title_version": "",
//  "link": "https://www.deezer.com/track/77698470",
//  "duration": 233,
//  "rank": 894568,
//  "explicit_lyrics": false,
//  "explicit_content_lyrics": 6,
//  "explicit_content_cover": 2,
//  "preview": "https://cdns-preview-e.dzcdn.net/stream/c-e7c1e888c73aaf9c7d063f3598be6147-6.mp3",
//  "contributors": [
//    {
//      "id": 734,
//      "name": "Magic System",
//      "link": "https://www.deezer.com/artist/734",
//      "share": "https://www.deezer.com/artist/734?utm_source=deezer&utm_content=artist-734&utm_term=0_1696693065&utm_medium=web",
//      "picture": "https://api.deezer.com/artist/734/image",
//      "picture_small": "https://e-cdns-images.dzcdn.net/images/artist/de7ce17218a913079da4d45d53ada004/56x56-000000-80-0-0.jpg",
//      "picture_medium": "https://e-cdns-images.dzcdn.net/images/artist/de7ce17218a913079da4d45d53ada004/250x250-000000-80-0-0.jpg",
//      "picture_big": "https://e-cdns-images.dzcdn.net/images/artist/de7ce17218a913079da4d45d53ada004/500x500-000000-80-0-0.jpg",
//      "picture_xl": "https://e-cdns-images.dzcdn.net/images/artist/de7ce17218a913079da4d45d53ada004/1000x1000-000000-80-0-0.jpg",
//      "radio": true,
//      "tracklist": "https://api.deezer.com/artist/734/top?limit=50",
//      "type": "artist",
//      "role": "Main"
//    },
//    {
//      "id": 1279116,
//      "name": "Chawki",
//      "link": "https://www.deezer.com/artist/1279116",
//      "share": "https://www.deezer.com/artist/1279116?utm_source=deezer&utm_content=artist-1279116&utm_term=0_1696693065&utm_medium=web",
//      "picture": "https://api.deezer.com/artist/1279116/image",
//      "picture_small": "https://e-cdns-images.dzcdn.net/images/artist/e7707031cf85edfb75ce4ba8b294b251/56x56-000000-80-0-0.jpg",
//      "picture_medium": "https://e-cdns-images.dzcdn.net/images/artist/e7707031cf85edfb75ce4ba8b294b251/250x250-000000-80-0-0.jpg",
//      "picture_big": "https://e-cdns-images.dzcdn.net/images/artist/e7707031cf85edfb75ce4ba8b294b251/500x500-000000-80-0-0.jpg",
//      "picture_xl": "https://e-cdns-images.dzcdn.net/images/artist/e7707031cf85edfb75ce4ba8b294b251/1000x1000-000000-80-0-0.jpg",
//      "radio": true,
//      "tracklist": "https://api.deezer.com/artist/1279116/top?limit=50",
//      "type": "artist",
//      "role": "Featured"
//    }
//  ],
//  "md5_image": "9a71de78221c8c2d4225865ede8b49eb",
//  "artist": {
//    "id": 734,
//    "name": "Magic System",
//    "tracklist": "https://api.deezer.com/artist/734/top?limit=50",
//    "type": "artist"
//  },
//  "album": {
//    "id": 7720996,
//    "title": "Africainement vôtre",
//    "cover": "https://api.deezer.com/album/7720996/image",
//    "cover_small": "https://e-cdns-images.dzcdn.net/images/cover/9a71de78221c8c2d4225865ede8b49eb/56x56-000000-80-0-0.jpg",
//    "cover_medium": "https://e-cdns-images.dzcdn.net/images/cover/9a71de78221c8c2d4225865ede8b49eb/250x250-000000-80-0-0.jpg",
//    "cover_big": "https://e-cdns-images.dzcdn.net/images/cover/9a71de78221c8c2d4225865ede8b49eb/500x500-000000-80-0-0.jpg",
//    "cover_xl": "https://e-cdns-images.dzcdn.net/images/cover/9a71de78221c8c2d4225865ede8b49eb/1000x1000-000000-80-0-0.jpg",
//    "md5_image": "9a71de78221c8c2d4225865ede8b49eb",
//    "tracklist": "https://api.deezer.com/album/7720996/tracks",
//    "type": "album"
//  },
//  "type": "track"
//}
