# Setup and run App
```sh
docker-compose build
docker-compose up
docker-compose exec web rake db:create
docker-compose exec web rake db:migrate
```

# API Documentation
Creating Project
```json
POST /api/v1/projects

{
  "title": "Work"
}
```
| Field       | Required | Description |
| ---------- |:------------:|:------------:|
| `title`       | Yes           | Title of the project|
### Successful response
```json
201 Created

{
  "data": [{
    "id": "1",
    "attributes": {
      "title": "Work"
    },
    "relationships": {
      "tasks": {
        "data": []
      }
    },
    "type": "projects",
  }]
}
```
| Field   | Description |
| ------ |:------------:|
| id     | ID of the project|
| title | Current title of the project|
### Unsuccessful response
```json
400 Bad request

{
  "errors": [{
    "status": 400,
    "detail": "can't be blank",
    "source": {
      "pointer": "/data/attributes/title"
    }
  }]
}
```
Updating Project
```json
PUT /api/v1/projects/:id

{
  "title": "Study"
}
```
| Field       | Required | Description |
| ---------- |:------------:|:------------:|
| `title`       | Yes           | Title of the project|
### Successful response
```json
200 Updated

{
  "data": [{
    "id": "1",
    "attributes": {
      "title": "Study"
    },
    "relationships": {
      "tasks": {
        "data": []
      }
    },
    "type": "projects",
  }]
}
```
| Field   | Description |
| ------ |:------------:|
| id     | ID of the project|
| title | Current title of the project|
### Unsuccessful response
```json
{
  "title": ""
}

400 Bad request

{
  "errors": [{
    "status": 400,
    "detail": "can't be blank",
    "source": {
      "pointer": "/data/attributes/title"
    }
  }]
}
```
## Get project by ID
### Query
```
GET /api/v1/projects/:id
```
### Response
```json
200 Ok
{
  "data": [
    {
      "id": "1",
      "attributes": {
        "title": "Work"
      },
      "relationships": {
        "tasks": {
          "data": []
        }
      },
      "type": "projects",
    }
  ]
}
```
### Unsuccessful response
```json
400 Bad request

{
  "errors": [{
    "id": "2",
    "status": 404,
    "detail": "Couldn't find Project with 'id'=2"
  }]
}
```
## Get list projects
### Query
```
GET /api/v1/projects
```
### Response
```json
200 Ok
{
  "data": [
    {
      "id": "1",
      "attributes": {
        "title": "Work"
      },
      "relationships": {
        "tasks": {
          "data": []
        }
      },
      "type": "projects",
    },
    {
      "id": "2",
      "attributes": {
        "title": "Home"
      },
      "relationships": {
        "tasks": {
          "data": []
        }
      },
      "type": "projects",
    }
  ]
}
```
## Delete project
### Query
```
DELETE /api/v1/projects/:id
```
### Response
```json
200 Ok
```
