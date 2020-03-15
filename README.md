# Setup and run App
```sh
docker-compose build
docker-compose up
docker-compose exec web rake db:create
docker-compose exec web rake db:migrate
```

# API Documentation
## Projects
Creating Project
### Query
```
POST /api/v1/projects
```
```json
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
### Query
```
PUT /api/v1/projects/:id
```
```json
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

## Tasks
Creating Tasks
### Query
```
POST /api/v1/projects/:project_id/tasks
```
```json
{
  "title": "Fix Bug"
}
```
| Field       | Required | Description |
| ---------- |:------------:|:------------:|
| `title`       | Yes           | Title of the task|
### Successful response
```json
201 Created

{
  "data": [{
    "id": "1",
    "type": "tasks",
    "attributes": {
      "title": "Fix Bug",
      "status": "created"
    },
    "relationships": {
      "project": {
        "data": {
          "id": "1",
          "type": "projects"
        }
      }
    },
  }]
}
```
| Field   | Description |
| ------ |:------------:|
| `id`     | ID of the task|
| `title` | Current title of the task|
| `status` | Current title of the task. Ca be `created` or `done`|
### Statuses of the task
| Title    | Description                     |
| ---------- |:----------------------------:|
| `created`  | Task is created(default)|
| `done`  | Marked task as done|

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
Updating Task
### Query
```
PUT /api/v1/projects/:project_id/tasks/:id
```
```json
{
  "title": "Send email"
}
```
| Field       | Required | Description |
| ---------- |:------------:|:------------:|
| `title`       | Yes           | Title of the project|
### Successful response
```json
```json
200 Ok

{
  "data": [{
    "id": "1",
    "type": "tasks",
    "attributes": {
      "title": "Send email",
      "status": "created"
    },
    "relationships": {
      "project": {
        "data": {
          "id": "1",
          "type": "projects"
        }
      }
    },
  }]
}
```
| Field   | Description |
| ------ |:------------:|
| `id`     | ID of the task|
| `title` | Current title of the task|
| `status` | Current title of the task. Ca be `created` or `done`|

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
## Get task by ID
### Query
```
GET /api/v1/projects/:project_id/tasks/:id
```
### Response
```json
200 Ok
{
  "data": [{
    "id": "1",
    "type": "tasks",
    "attributes": {
      "title": "Send email",
      "status": "created"
    },
    "relationships": {
      "project": {
        "data": {
          "id": "1",
          "type": "projects"
        }
      }
    },
  }]
}
```
### Unsuccessful response
```json
400 Bad request

{
  "errors": [{
    "id": "2",
    "status": 404,
    "detail": "Couldn't find Task with 'id'=2"
  }]
}
```
## Get list tasks
### Query
```
GET /api/v1/projects/:project_id/tasks
```

| Param   | Description |  |Required|
| ------ |:------------:|:------------:|
| `sort`     | asc|desc| false
### Response
```json
200 Ok
{
              "data": [
                {
                  "id": "1",
                  "type": "tasks",
                  "attributes": {
                    "title": "Fix bug",
                    "status": "created"
                  },
                  "relationships": {
                    "project": {
                      "data": {
                        "id": "1",
                        "type": "projects",
                      }
                    }
                  },
                },
                {
                  "id": "2",
                  "type": "tasks",
                  "attributes": {
                    "title": "Do some feature",
                    "status": "created"
                  },
                  "relationships": {
                    "project": {
                      "data": {
                        "id": "1",
                        "type": "projects",
                      }
                    }
                  },
                },
              ]
            }
```
## Delete task
### Query
```
DELETE /api/v1/projects/:project_id/tasks/:id
```
### Response
```json
200 Ok
```


