config = {
  host: "https://elastic:Lrag0HDsUlPaQfSIUvnM@localhost:9200",
  transport_options: {
    request: { timeout: 5 },
	ssl: { verify: false }
  },
  ca_fingerprint: "66cd90f2557581073e81091dfefff3cb4e9e078bf272ba6effb9695d6c6dcf66"
}

Elasticsearch::Model.client = Elasticsearch::Client.new(config)
