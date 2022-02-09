# Brightwheel challenge

* Ruby version: 2.7.2

## Instructions

In order to have the app running, the following steps should be executed

* bundle install

* `bundle exec rails s` (the server will be listening in the port 3000)

* for running the specs execute `bundle exec rspec`

## Endpoints

* POST `api/v1/readings/record` for creating the readings.
    * request_body: `{ id: #uuid, readings: #array[ { timestamp: #iso8601 date string, count: #integer } ]}`
    * request_body_example: 
    ```
    {
        "id": "36d5658a-6908-479e-887e-a949ec199272",
        "readings": [
            {
                "timestamp": "2021-09-29T16:08:15+01:00",
                "count": 2
            },
            {
                "timestamp": "2021-09-29T16:09:15+01:00",
                "count": 15
            }
        ]
    }
```
    * response: no content page with a 201 status code.

* GET `api/v1/readings/:device_id/total_count` for getting the total count of an specific id
    * params: `device_id` - the device identifier related to the readings
    * response: a json containing the total amount of counts for that identifier `{ total_count: #integer }`

* GET `api/v1/readings/:device_id/most_recent` for getting the most recent reading related to an specific id

## Design Notes

* Services are used for controlling all the business logic that the app requires. Controllers should not have business logic
and the models are only used for storing the object information.

* The ActiveModel validations module is included in the models to make easier handling the validations for that object.

* Since no database is allowed and is not valid persisting data on disk, a Database class is used for storing the information with class variables during the execution of the program. This approach is not considered as thread safe.

* The Database class have two attributes used for handling the information:
    * `records`: A hash for storing the readings as an array for an specific id (this improves the search time since a hash is O(1)
    * `checksums`: Since the same payload can be received more than once, a checksum for that payload is created and associated with the given id. With this approach, is easy to determinate if a payload was already received by the program. it is also a hash that stores an array of checksums for the different payloads an id can receive.
    
* The route for creating the readings is created as `record` insteand of `create` since we are actually able to bulk create them, so would be weird to use a CRUD route for creating multiple elements at the same time.
    
* Services are implemented with only one purpose to encapsulate behavior and make easier debugging and testing. 

## Additional Time goals

* Implement a centralized way to render the responses (maybe a renderable module) to have a RESTful API standard.
* Adding Services, Routing and Model specs (model specs for custom validators)
* Implement a centralized way to handle exceptions (like `rescue_from`) in the application controller so error messages can be more readable and the app can revocer from errors.
* Creating the service for getting the latest reading associated to an id.
* Implement the Database class in a more generic way so multiple records of different classes can be stored.
* For the checksum generator, create a way to obtain the same checksum if the payload is the same but the order of some elements are different.
* Generalized services responses and avoid creating the json inside of them.
