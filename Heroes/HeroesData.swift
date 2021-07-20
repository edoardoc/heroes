//
//  HeroesData.swift
//  Heroes
//
//  Created by Edoardo on 18/07/2021.
//


/*

SAMPLE RESPONSE

{
  "code": 200,
  "status": "Ok",
  "copyright": "© 2021 MARVEL",
  "attributionText": "Data provided by Marvel. © 2021 MARVEL",
  "attributionHTML": "<a href=\"http://marvel.com\">Data provided by Marvel. © 2021 MARVEL</a>",
  "etag": "55dfcdee8fb6acae09bbb914507c6cf48cd8975f",
  "data": {
    "offset": 50,
    "limit": 1,
    "total": 1493,
    "count": 1,
    "results": [
      {
        "id": 1011301,
        "name": "Anole",
        "description": "",
        "modified": "1969-12-31T19:00:00-0500",
        "thumbnail": {
          "path": "http://i.annihil.us/u/prod/marvel/i/mg/9/20/4c002e635ddd9",
          "extension": "jpg"
        },
        "resourceURI": "http://gateway.marvel.com/v1/public/characters/1011301",
        "comics": {
          "available": 5,
          "collectionURI": "http://gateway.marvel.com/v1/public/characters/1011301/comics",
          "items": [
            {
              "resourceURI": "http://gateway.marvel.com/v1/public/comics/73064",
              "name": "Age Of X-Man: Nextgen (Trade Paperback)"
            },
            {
              "resourceURI": "http://gateway.marvel.com/v1/public/comics/24173",
              "name": "Runaways (2008) #10"
            },
            {
              "resourceURI": "http://gateway.marvel.com/v1/public/comics/26970",
              "name": "Uncanny X-Men (1963) #517"
            },
            {
              "resourceURI": "http://gateway.marvel.com/v1/public/comics/79949",
              "name": "X-Men (2019) #11"
            },
            {
              "resourceURI": "http://gateway.marvel.com/v1/public/comics/79950",
              "name": "X-Men (2019) #12"
            }
          ],
          "returned": 5
        },
        "series": {
          "available": 4,
          "collectionURI": "http://gateway.marvel.com/v1/public/characters/1011301/series",
          "items": [
            {
              "resourceURI": "http://gateway.marvel.com/v1/public/series/26372",
              "name": "Age Of X-Man: Nextgen (2019)"
            },
            {
              "resourceURI": "http://gateway.marvel.com/v1/public/series/5338",
              "name": "Runaways (2008 - 2009)"
            },
            {
              "resourceURI": "http://gateway.marvel.com/v1/public/series/2258",
              "name": "Uncanny X-Men (1963 - 2011)"
            },
            {
              "resourceURI": "http://gateway.marvel.com/v1/public/series/27567",
              "name": "X-Men (2019 - Present)"
            }
          ],
          "returned": 4
        },
        "stories": {
          "available": 5,
          "collectionURI": "http://gateway.marvel.com/v1/public/characters/1011301/stories",
          "items": [
            {
              "resourceURI": "http://gateway.marvel.com/v1/public/stories/53571",
              "name": "Interior #53571",
              "type": "interiorStory"
            },
            {
              "resourceURI": "http://gateway.marvel.com/v1/public/stories/59253",
              "name": "Interior #59253",
              "type": "interiorStory"
            },
            {
              "resourceURI": "http://gateway.marvel.com/v1/public/stories/162802",
              "name": "cover from AGE OF X-MAN: TBD B TPB (2019) #1",
              "type": "cover"
            },
            {
              "resourceURI": "http://gateway.marvel.com/v1/public/stories/176967",
              "name": "cover from X-Men (2019) #11",
              "type": "cover"
            },
            {
              "resourceURI": "http://gateway.marvel.com/v1/public/stories/176969",
              "name": "cover from X-Men (2019) #12",
              "type": "cover"
            }
          ],
          "returned": 5
        },
        "events": {
          "available": 0,
          "collectionURI": "http://gateway.marvel.com/v1/public/characters/1011301/events",
          "items": [],
          "returned": 0
        },
        "urls": [
          {
            "type": "detail",
            "url": "http://marvel.com/characters/155/anole?utm_campaign=apiRef&utm_source=8c20814552fcd4f513adb7f15c67a39b"
          },
          {
            "type": "wiki",
            "url": "http://marvel.com/universe/Anole?utm_campaign=apiRef&utm_source=8c20814552fcd4f513adb7f15c67a39b"
          },
          {
            "type": "comiclink",
            "url": "http://marvel.com/comics/characters/1011301/anole?utm_campaign=apiRef&utm_source=8c20814552fcd4f513adb7f15c67a39b"
          }
        ]
      }
    ]
  }
}





*/


import Foundation
import Combine

enum HeroesData {
    static let pageSize = 10
    
    static func getHeroesResponse(page: Int) -> AnyPublisher<[Hero], Error> {
        let url = URL(
            referer:"developer.marvel.com",
            string: "http://gateway.marvel.com:80/v1/public/characters?apikey=8c20814552fcd4f513adb7f15c67a39b&limit=\(Self.pageSize)&offset=\(page)")!
        return URLSession.shared
            
            .dataTaskPublisher(for: url)
            .handleEvents(receiveOutput: { print(NSString(data: $0.data, encoding: String.Encoding.utf8.rawValue)!) })
            .tryMap { try JSONDecoder().decode(HeroesDataResponse<Hero>.self, from: $0.data).items }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct HeroesDataResponse<T: Codable>: Codable {
    let items: [T]
}

struct Hero: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let description: String?
}
