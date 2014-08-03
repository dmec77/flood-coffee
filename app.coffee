express = require 'express'
app = express()

app.use('/static', express.static("#{__dirname}/static"))

app.get('/', (req, res) ->
  res.sendfile("#{__dirname}/index.html")
)

server = app.listen(3000)
