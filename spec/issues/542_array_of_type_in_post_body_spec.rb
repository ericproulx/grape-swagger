# frozen_string_literal: true

require 'spec_helper'

describe '#542 array of type in post params' do
  let(:app) do
    Class.new(Grape::API) do
      namespace :issue_542 do
        params do
          requires :logs, type: Array[String], documentation: { param_type: 'body' }
        end

        post do
          present params
        end
      end

      add_swagger_documentation format: :json
    end
  end

  subject do
    get '/swagger_doc'
    JSON.parse(last_response.body)
  end

  let(:parameters) { subject['paths']['/issue_542']['post']['parameters'] }
  let(:definitions) { subject['definitions'] }

  specify do
    expect(parameters).to eql(
      [
        {
          'in' => 'body',
          'name' => 'postIssue542',
          'required' => true,
          'schema' => {
            '$ref' => '#/definitions/postIssue542'
          }
        }
      ]
    )
  end

  specify do
    expect(definitions).to include(
      'postIssue542' => {
        'type' => 'object',
        'properties' => {
          'logs' => {
            'type' => 'array',
            'items' => {
              'type' => 'string'
            }
          }
        },
        'required' => ['logs']
      }
    )
  end
end
