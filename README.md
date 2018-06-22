# Siftsciex

A Native Elixir library for interfacing with Sift Science's API.

This library currently supports the [Score API](https://siftscience.com/developers/docs/curl/score-api/overview) and a small part of the [Events API](https://siftscience.com/developers/docs/curl/events-api/overview).

The following events are implemented currently:

  * `create_content`
    * `listing`
    * `message`
  * `update_content`
    * `listing`
    * `message`
  * `create_account`
  * `update_account`

The goal with this library is _full support_ of the Sift Science API so anything not currently supported is definitely a goal.  If there is something you are looking for sooner rather than later PRs are most welcome or feel free to open an issue and we will get to it as time permits.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `siftsciex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:siftsciex, "~> 0.2.0"}
  ]
end
```

## Usage

Siftsciex basically does two things for you.  First, it manages translating an "intermediate" structure into a JSON format Sift Science will accept.  Additionally, it manages all the HTTP transport and response processing for you as well.  Siftsciex tries to type things as explicitly as possible, hopefully if there is any confusion careful investigation of the types can help clear things up.

### Events

Sift Science allows for two "flows" when it comes ot reporting events.  You can either simply report the event or you can report _synchronously_ in which case the HTTP Request will stay open until Sift comes up with a risk score for the Event and that data will be returned in the response.  The benefit of the Synchronous Event reporting is that you can get an answer before continuing with your business logic.  In situations where an action or piece of data may be critical or dangerous you can prevent anything from continuing until you know how risky the event is.  On the other hand these requests take longer so you probably don't want to make them when it isn't critical.

By default Siftsciex treats all Events as asynchronous, if you wish an Event to be reported synchrounously you still have full control over that behavior but must be explicit.

Sift Science has a very specific format for all the Events they consume (other than custom) which means you will likely need to perform some mapping to get your data into the right "shape".  With this in mind all the Event shapes have been fully typed out in `Siftsciex`, [dialyxir](https://hex.pm/packages/dialyxir) should be able to help you check that your mappings are correct.

### Scores

Scores represent the level of Risk a user represents in several different categories.  There are technically 5 risk categories and then the legacy risk score.  The 5 risk categories are:

  * `payment_abuse`
  * `account_abuse`
  * `content_abuse`
  * `promotion_abuse`
  * `account_takeover`

When making a query to the Score API you can indicate which of these scores you wish returned for the user.  There is some other metadata that comes across with a Score you can read more about that [here](https://siftscience.com/developers/docs/curl/score-api/synchronous-scores).  A Score can be requested independently at any time or it can be requested in the response to reporting an Event.
