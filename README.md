# request-handler
User-class for Alamofire requests.

## Usage:
*GET* methods with model mapping via *Codable* protocol
```Swift
RequestHandler(path: "user/1").response { (user: User?) in
  print(user)
}
```

*POST* methods without model mappng
```Swift
RequestHandler(path: "user",
               method: .post,
               parameters: ["id": 5]).responseJSON { (json) in
                 print(json)
               }
```

## Why i should use it?
1. *Incapsulate all requests*
2. *OOD Principles*
3. *Sugar-syntax*
4. *One-place header signing*
5. *Own code-layer on external library*
