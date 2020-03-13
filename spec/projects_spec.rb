require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Projects" do
  let(:parsed_response_body) { JSON.parse(response_body).deep_symbolize_keys }

  get "api/v1/projects" do
    example "returns 200" do
      do_request

      expect(status).to eq 200
    end

    context "when no projects" do
      example "returns empty json" do
        do_request

        expect(parsed_response_body[:data]).to eq([])
      end
    end

    context "when created a few projects" do
      let!(:projects) { create_list(:project, 2) }
      let(:expected_response) do
          {
            data: [
              {
                id: Project.first.id.to_s,
                attributes: {
                  title: Project.first.title
                },
                relationships: {
                  tasks: {
                    data: []
                  }
                },
                type: "projects",
              },
              {
                id: Project.second.id.to_s,
                attributes: {
                  title: Project.last.title
                },
                relationships: {
                  tasks: {
                    data: []
                  }
                },
                type: "projects",
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

      example "returns 2 projects" do
        do_request

        expect(parsed_response_body[:data].count).to eq(2)
      end

      example "returns listings projects" do
        do_request

        expect(parsed_response_body).to eq(expected_response)
      end
    end
  end

  get "api/v1/projects/:id" do
    context "success" do
      let(:project) { create(:project) }
      let(:id) { project.id }

      let(:expected_response) do
        {
          data: [
            {
              id: project.id.to_s,
              attributes: {
                title: project.title
              },
              relationships: {
                tasks: {
                  data: []
                }
              },
              type: "projects",
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
      let(:expected_response) do
        {
          errors: [{
            id: id.to_s,
            status: 404,
            detail: "Couldn't find Project with 'id'=#{id}"
          }]
        }
      end

      context "when id = 1" do
        let(:id) { 1 }

        example "return 404" do
          do_request

          expect(status).to eq 404
        end

        example "returns expected response" do
          do_request

          expect(parsed_response_body).to eq expected_response
        end
      end

      context "when id equal g" do
        let(:id) { "g" }

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

  post "api/v1/projects" do
    parameter :title, "Title project"

    context "success" do
      let(:params) do
        {
          title: "New project"
        }
      end

      let(:expected_response) do
        {
          data: [{
            id: Project.last.id.to_s,
            attributes: {
              title: "New project"
            },
            relationships: {
              tasks: {
                data: []
              }
            },
            type: "projects",
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

      context "when title is duplicated" do
        let!(:project) { create(:project, title: "New title") }

        let(:params) do
          {
            title: "New title"
          }
        end

        let(:expected_response) do
          {
            errors: [{
              status: 422,
              detail: "has already been taken",
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

  put "api/v1/projects/:id" do
    parameter :title, "Title project"

    context "success" do
      let(:project) { create(:project) }
      let(:id) { project.id }

      let(:params) do
        {
          title: "Updated title project"
        }
      end

      let(:expected_response) do
        {
          data: [{
            id: project.id.to_s,
            attributes: {
              title: "Updated title project"
            },
            relationships: {
              tasks: {
                data: []
              }
            },
            type: "projects",
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
      let(:project) { create(:project) }
      let(:id) { project.id }

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

  delete "api/v1/projects/:id" do
    context "success" do
      let(:project) { create(:project) }
      let(:id) { project.id }

      example "returns 204" do
        do_request

        expect(status).to eq 204
      end

      example "returns 0 project" do
        do_request

        expect(Project.count).to eq 0
      end
    end

    context "failure" do
      let(:id) { "g" }

      let(:expected_response) do
        {
          errors: [{
            id: id.to_s,
            status: 404,
            detail: "Couldn't find Project with 'id'=#{id}"
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
