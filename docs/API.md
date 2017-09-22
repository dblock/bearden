# Bearden API

### Explore the API

TODO

### Authentication

Trusted apps may use the Bearden API using [JWT](https://jwt.io/) authentication. You will need to obtain a JWT for Bearden from a Gravity console:

```ruby
# in a gravity console
app = ClientApplication.where(name: 'Bearden').first
expires_in = 20.years.from_now
token = ApplicationTrust.create_for_token_authentication(app, expires_in: expires_in)
puts token
```

Once in possession of the token, send it in your requests to Bearden:

```ruby
headers = { 'Authorization' => "Bearer #{token}" }
```

### Curl

```
export BEARDEN_TOKEN=...
curl https://bearden.artsy.net/api -H "Authorization:Bearer $BEARDEN_TOKEN"
```

### Hyperclient

```ruby
require 'hyperclient'

client = Hyperclient.new('https://bearden.artsy.net/api') do |client|
  client.headers = {
    'Authorization' => "Bearer #{token}"
  }
end

p client.status.timestamp

client.organizations(term: 'Gallery').each do |org|
  # org.names
end
```
