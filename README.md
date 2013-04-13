# Example LTI Tool Provider Using rack-lti

This is a basic and simple LTI Tool Provider that uses the
[rack-lti](https://github.com/zachpendleton/rack-lti) rack middleware.
To get this running in your development environment, check out the repo then:

    bundle install
    bundle exec shotgun

You can use the XML from the `/tool_config.xml` endpoint to configure the tool in a Tool Consumer.

You can use this with the [example LTI Tool Consumer](https://github.com/instructure/lti_tool_consumer_example)
to do some simple LTI testing.
