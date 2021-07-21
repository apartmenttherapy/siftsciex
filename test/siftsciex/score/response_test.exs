defmodule Siftsciex.Score.ResponseTest do
  use ExUnit.Case

  alias Siftsciex.Score.Response

  doctest Response

  describe "synchronous workflow" do
    @response_body """
    {
      "status":0,
      "error_message":"OK",
      "user_id":"billy_jones_301",
      "scores":{
        "payment_abuse":{
          "score":0.898391231245,
          "reasons":[
            {
              "name":"UsersPerDevice",
              "value":4,
              "details":{
                "users":"a, b, c, d"
              }
            }
          ]
        },
        "promotion_abuse":{
          "score":0.472838192111,
          "reasons":[

          ]
        }
      },
      "latest_labels":{
        "payment_abuse":{
          "is_fraud":true,
          "time":1352201880,
          "description":"received a chargeback"
        },
        "promotion_abuse":{
          "is_fraud":false,
          "time":1362205000
        }
      },
      "workflow_statuses":[
        {
          "id":"6dbq76qbaaaaa",
          "state":"running",
          "config":{
            "id":"pv3u5hyaaa",
            "version":"1468013109122"
          },
          "config_display_name":"my create order flow",
          "abuse_types":[
            "payment_abuse",
            "legacy"
          ],
          "entity":{
            "type":"user",
            "id":"test"
          },
          "history":[
            {
              "app":"decision",
              "name":"ban user",
              "state":"running",
              "config":{
                "decision_id":"ban-user-payment-abuse"
              }
            },
            {
              "app":"review_queue",
              "name":"risky user queue",
              "state":"finished",
              "config":{
                "buttons":[
                  {
                    "id":"ban-user-payment-abuse",
                    "name":"Ban User"
                  },
                  {
                    "id":"suspend-user-payment-abuse",
                    "name":"Ban User"
                  },
                  {
                    "id":"accept-user-payment-abuse",
                    "name":"Ban User"
                  }
                ]
              }
            },
            {
              "app":"user_scorer",
              "name":"Entity",
              "state":"finished"
            },
            {
              "app":"event_processor",
              "name":"Event",
              "state":"finished"
            }
          ]
        }
      ]
    }
    """

    test "parsed the response" do
      expected =
      %Siftsciex.Score.Response{
        error_message: "OK",
        latest_labels: %{
          payment_abuse: %Siftsciex.Score.Response.Label{
            description: "received a chargeback",
            is_bad: :empty,
            time: ~U[2012-11-06 11:38:00Z]
          },
          promotion_abuse: %Siftsciex.Score.Response.Label{
            description: :empty,
            is_bad: :empty,
            time: ~U[2013-03-02 06:16:40Z]
          }
        },
        scores: [
          %Siftsciex.Score.Response.Score{
            reasons: [
              %Siftsciex.Score.Response.Reason{
                details: %{users: "a, b, c, d"},
                name: "UsersPerDevice",
                value: 4
              }
            ],
            score: 0.898391231245,
            type: :payment_abuse
          },
          %Siftsciex.Score.Response.Score{
            reasons: [],
            score: 0.472838192111,
            type: :promotion_abuse
          }
        ],
        status: 0,
        user_id: "billy_jones_301",
        workflow_statuses: [
          %Siftsciex.Score.Response.WorkflowStatus{
            abuse_types: [:payment_abuse, :legacy],
            config: %Siftsciex.Score.Response.WorkflowStatus.Config{
              id: "pv3u5hyaaa",
              version: "1468013109122"
            },
            config_display_name: "my create order flow",
            entity: %Siftsciex.Score.Response.WorkflowStatus.Entity{
              id: "test",
              type: :user
            },
            history: [
              %Siftsciex.Score.Response.WorkflowStatus.Stage{
                app: "decision",
                config: %Siftsciex.Score.Response.WorkflowStatus.StageConfig{
                  buttons: :empty,
                  decision_id: "ban-user-payment-abuse"
                },
                name: "ban user",
                state: :running
              },
              %Siftsciex.Score.Response.WorkflowStatus.Stage{
                app: "review_queue",
                config: %Siftsciex.Score.Response.WorkflowStatus.StageConfig{
                  buttons: [
                    %Siftsciex.Score.Response.WorkflowStatus.Button{
                      id: "ban-user-payment-abuse",
                      name: "Ban User"
                    },
                    %Siftsciex.Score.Response.WorkflowStatus.Button{
                      id: "suspend-user-payment-abuse",
                      name: "Ban User"
                    },
                    %Siftsciex.Score.Response.WorkflowStatus.Button{
                      id: "accept-user-payment-abuse",
                      name: "Ban User"
                    }
                  ],
                  decision_id: :empty
                },
                name: "risky user queue",
                state: :finished
              },
              %Siftsciex.Score.Response.WorkflowStatus.Stage{
                app: "user_scorer",
                config: :empty,
                name: "Entity",
                state: :finished
              },
              %Siftsciex.Score.Response.WorkflowStatus.Stage{
                app: "event_processor",
                config: :empty,
                name: "Event",
                state: :finished
              }
            ],
            id: "6dbq76qbaaaaa",
            state: :running
          }
        ]
      }

      result = Response.process(@response_body)

      assert result == expected
    end
  end
end
