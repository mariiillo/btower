# Echo server

This app will allow you to mock your endpoints

##Project setup

* Database

`bundle exec rake db:setup`

* How to run the test suite

`bundle exec rspec`

* How to run the app

`bundle exec rails server`

##Functionality

<details>
  <summary>List endpoints</summary>
  <markdown>
#### Request

    GET /endpoints HTTP/1.1
    Accept: application/vnd.api+json

#### Expected response

    HTTP/1.1 200 OK
    Content-Type: application/vnd.api+json

    {
        "data": [
            {
                "type": "endpoints",
                "id": "12345",
                "attributes": [
                    "verb": "GET",
                    "path": "/greeting",
                    "response": {
                      "code": 200,
                      "headers": {},
                      "body": "\"{ \"message\": \"Hello, world\" }\""
                    }
                ]
            }
        ]
    }
  </markdown>
</details>

<details>
  <summary>Create endpoint</summary>
  <markdown>
#### Request

    POST /endpoints HTTP/1.1
    Content-Type: application/vnd.api+json
    Accept: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "attributes": {
                "verb": "GET",
                "path": "/greeting",
                "response": {
                  "code": 200,
                  "headers": {},
                  "body": "\"{ \"message\": \"Hello, world\" }\""
                }
            }
        }
    }

#### Expected response

    HTTP/1.1 201 Created
    Location: http://example.com/greeting
    Content-Type: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "id": "12345",
            "attributes": {
                "verb": "GET",
                "path": "/greeting",
                "response": {
                  "code": 200,
                  "headers": {},
                  "body": "\"{ \"message\": \"Hello, world\" }\""
                }
            }
        }
    }
  </markdown>
</details>

<details>
  <summary>Update endpoint</summary>
  <markdown>
#### Request

    PATCH /endpoints/12345 HTTP/1.1
    Content-Type: application/vnd.api+json
    Accept: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "id": "12345"
            "attributes": {
                "verb": "POST",
                "path": "/greeting",
                "response": {
                  "code": 201,
                  "headers": {},
                  "body": "\"{ \"message\": \"Hello, everyone\" }\""
                }
            }
        }
    }


#### Expected response

    HTTP/1.1 200 OK
    Content-Type: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "id": "12345",
            "attributes": {
                "verb": "POST",
                "path": "/greeting",
                "response": {
                  "code": 201,
                  "headers": {},
                  "body": "\"{ \"message\": \"Hello, everyone\" }\""
                }
            }
        }
    }
  </markdown>
</details>

<details>
  <summary>Delete endpoint</summary>
  <markdown>
#### Request

    DELETE /endpoints/12345 HTTP/1.1
    Accept: application/vnd.api+json

#### Expected response

    HTTP/1.1 204 No Content
  </markdown>
</details>

<details>
  <summary>Error response</summary>
  <markdown>
In case client makes unexpected response or server encountered an internal problem, Echo should provide proper error response.

#### Request

    DELETE /endpoints/1234567890 HTTP/1.1
    Accept: application/vnd.api+json

#### Expected response

    HTTP/1.1 404 Not found
    Content-Type: application/vnd.api+json

    {
        "errors": [
            {
                "code": "not_found",
                "detail": "Requested Endpoint with ID `1234567890` does not exist"
            }
        ]
    }
  </markdown>
</details>

<details open>
  <summary>Sample scenario</summary>
  <markdown>

#### 1. Client requests non-existing path

    > GET /hello HTTP/1.1
    > Accept: application/vnd.api+json

    HTTP/1.1 404 Not found
    Content-Type: application/vnd.api+json

    {
        "errors": [
            {
                "code": "not_found",
                "detail": "Requested page `/hello` does not exist"
            }
        ]
    }

#### 2. Client creates an endpoint

    > POST /endpoints HTTP/1.1
    > Content-Type: application/vnd.api+json
    > Accept: application/vnd.api+json
    >
    > {
    >     "data": {
    >         "type": "endpoints",
    >         "attributes": {
    >             "verb": "GET",
    >             "path": "/hello",
    >             "response": {
    >                 "code": 200,
    >                 "headers": {
    >                     "Content-Type": "application/json"
    >                 },
    >                 "body": "\"{ \"message\": \"Hello, world\" }\""
    >             }
    >         }
    >     }
    > }

    HTTP/1.1 201 Created
    Location: http://example.com/hello
    Content-Type: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "id": "12345",
            "attributes": {
                "verb": "GET",
                "path": "/hello",
                "response": {
                    "code": 200,
                    "headers": {
                        "Content-Type": "application/json"
                    },
                    "body": "\"{ \"message\": \"Hello, world\" }\""
                }
            }
        }
    }

#### 3. Client requests the recently created endpoint

    > GET /hello HTTP/1.1
    > Accept: application/json

    HTTP/1.1 200 OK
    Content-Type: application/json

    { "message": "Hello, world" }

#### 4. Client requests the endpoint on the same path, but with different HTTP verb

The server responds with HTTP 404 because only `GET /hello` endpoint is defined.

NOTE: if you could imagine different behavior from the server, feel free to propose it in your solution.

    > POST /hello HTTP/1.1
    > Accept: application/vnd.api+json

    HTTP/1.1 404 Not found
    Content-Type: application/vnd.api+json
git 
    {
        "errors": [
            {
                "code": "not_found",
                "detail": "Requested page `/hello` does not exist"
            }
        ]
    }

  </markdown>
</details>
