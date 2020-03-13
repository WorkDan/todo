require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Tasks" do
  let(:parsed_response_body) { JSON.parse(response_body).deep_symbolize_keys }
  let(:project) { create(:project) }

  get "api/v1/projects/:project_id/tasks" do
    parameter :project_id, "Project ID"
    context "success" do
      let(:project_id) { project.id }

      example "returns 200" do
        do_request

        expect(status).to eq 200
      end

      context "when no tasks" do
        example "returns empty json" do
          do_request

          expect(parsed_response_body[:data]).to eq([])
        end
      end

      context "when created a few tasks" do
        let!(:tasks) { create_list(:task, 2, project: project) }
        let(:expected_response) do
            {
              data: [
                {
                  id: Task.first.id.to_s,
                  type: "tasks",
                  attributes: {
                    title: Task.first.title
                  },
                  relationships: {
                    project: {
                      data: {
                        id: Project.first.id.to_s,
                        type: "projects",
                      }
                    }
                  },
                },
                {
                  id: Task.last.id.to_s,
                  type: "tasks",
                  attributes: {
                    title: Task.last.title
                  },
                  relationships: {
                    project: {
                      data: {
                        id: Project.first.id.to_s,
                        type: "projects",
                      }
                    }
                  },
                },
              ]
            }
        end

        let(:expected_keys) do
          [:id, :type, :attributes, :relationships]
        end

        example "returns array object" do
          do_request

          expect(parsed_response_body[:data]).to be_an_instance_of Array
        end

        example "returns expected keys" do
          do_request

          expect(parsed_response_body[:data][0].keys).to eq(expected_keys)
        end

        example "returns 2 tasks" do
          do_request

          expect(parsed_response_body[:data].count).to eq(2)
        end

        example "returns listings tasks" do
          do_request

          expect(parsed_response_body).to eq(expected_response)
        end
      end
    end

    context "failure" do
      let(:project_id) { "123" }

      let(:expected_response) do
        {
          errors: [{
            id: project_id.to_s,
            status: 404,
            detail: "Couldn't find Project with 'id'=#{project_id}"
          }]
        }
      end

      example "returns expected response" do
        do_request

        expect(parsed_response_body).to eq expected_response
      end
    end
  end

  get "api/v1/projects/:project_id/tasks/:id" do
    parameter :project_id, "Project ID"
    parameter :id, "Task ID"

    context "success" do
      let(:project_id) { project.id }

      let(:task) { create(:task, project: project) }
      let(:id) { task.id }

      let(:expected_response) do
        {
          data: [
            {
              type: "tasks",
              id: task.id.to_s,
              attributes: {
                title: task.title
              },
              relationships: {
                project: {
                  data: {
                    id: project.id.to_s,
                    type: "projects"
                  }
                }
              }
            }
          ]
        }
      end

      example "returns object" do
        do_request

        expect(parsed_response_body).to eq expected_response
      end
    end

    context "failure" do
      context "when project_id is wrong" do
        let(:project_id) { "12123" }

        let(:task) { create(:task, project: project) }
        let(:id) { task.id }
        let(:expected_response) do
          {
            errors: [{
              id: project_id.to_s,
              status: 404,
              detail: "Couldn't find Project with 'id'=#{project_id}"
            }]
          }
        end

        example "return 404" do
          do_request

          expect(status).to eq 404
        end

        example "returns expected response" do
          do_request

          expect(parsed_response_body).to eq expected_response
        end
      end

      context "when id equal is wrong" do
        let(:project_id) { project.id }
        let!(:task) { create(:task, project: project) }
        let(:id) { "g" }

        let(:expected_response) do
          {
            errors: [{
              id: id.to_s,
              status: 404,
              detail: "Couldn't find Task with 'id'=g [WHERE \"tasks\".\"project_id\" = $1]"
            }]
          }
        end

        example "return 404" do
          do_request

          expect(status).to eq 404
        end

        example "returns expected response" do
          do_request

          expect(parsed_response_body).to eq expected_response
        end
      end
    end
  end

  post "api/v1/projects/:project_id/tasks" do
    parameter :title, "Title project"
    parameter :project_id, "Project ID"

    context "success" do
      let(:project_id) { project.id }
      let(:params) do
        {
          title: "New task"
        }
      end

      let(:expected_response) do
        {
          data: [{
            id: Task.last.id.to_s,
            type: "tasks",
            attributes: {
              title: "New task"
            },
            relationships: {
              project: {
                data: {
                  id: Project.last.id.to_s, type: "projects"
                }
              }
            },
          }]
        }
      end

      example "returns 201" do
        do_request(params)

        expect(status).to eq 201
      end

      example "returns created project" do
        do_request(params)

        expect(parsed_response_body).to eq expected_response
      end
    end

    context "failure" do
      context "when title is empty" do
        let(:project_id) { project.id }

        let(:params) do
          {
            title: ""
          }
        end

        let(:expected_response) do
          {
            errors: [{
              status: 422,
              detail: "can't be blank",
              source: {
                pointer: "/data/attributes/title"
              }
            }]
          }
        end

        example "returns 422" do
          do_request(params)

          expect(status).to eq 422
        end

        example "returns expected result" do
          do_request(params)

          expect(parsed_response_body).to eq expected_response
        end
      end
    end
  end

  put "api/v1/projects/:project_id/tasks/:id" do
    parameter :title, "Title project"

    context "success" do
      let(:project_id) { project.id }
      let(:task) { create(:task, project: project) }
      let(:id) { task.id }

      let(:params) do
        {
          title: "Updated title project"
        }
      end

      let(:expected_response) do
        {
          data: [{
            id: task.id.to_s,
            type: "tasks",
            attributes: {
              title: "Updated title project"
            },
            relationships: {
              project: {
                data: {
                  id: Project.last.id.to_s,
                  type: "projects"
                }
              }
            }
          }]
        }
      end

      example "returns 200" do
        do_request(params)

        expect(status).to eq 200
      end

      example "returns updated project" do
        do_request(params)

        expect(parsed_response_body).to eq expected_response
      end
    end

    context "failure" do
      let(:project_id) { project.id }
      let(:task) { create(:task, project: project) }
      let(:id) { task.id }

      context "when title is empty" do
        let(:params) do
          {
            title: ""
          }
        end

        let(:expected_response) do
          {
            errors: [{
              status: 422,
              detail: "can't be blank",
              source: {
                pointer: "/data/attributes/title"
              }
            }]
          }
        end

        example "returns 422" do
          do_request(params)

          expect(status).to eq 422
        end

        example "returns expected result" do
          do_request(params)

          expect(parsed_response_body).to eq expected_response
        end
      end
    end
  end

  delete "api/v1/projects/:project_id/tasks/:id" do
    context "success" do
      let(:project_id) { project.id }
      let(:task) { create(:task, project: project) }
      let(:id) { task.id }

      example "returns 204" do
        do_request

        expect(status).to eq 204
      end

      example "returns 0 project" do
        do_request

        expect(Task.count).to eq 0
      end
    end

    context "failure" do
      let(:project_id) { project.id }
      let(:id) { "g" }

      let(:expected_response) do
        {
          errors: [{
            id: id.to_s,
            status: 404,
            detail: "Couldn't find Task with 'id'=#{id}"
          }]
        }
      end

      example "returns 422" do
        do_request

        expect(status).to eq 404
      end

      example "returns expected result" do
        do_request

        expect(parsed_response_body).to eq expected_response
      end
    end
  end
end
