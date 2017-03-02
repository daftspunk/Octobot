# Description:
# 	Poll Stack Overflow or fetch for new threads manually
#
# Commands:
# 	hubot check stackoverflow - Tests forum search results
#

Poller = require '../support/poller'

POLL_INTERVAL    = 1000 * 60 * 15 # 15 minute interval to start with
ANNOUNCE_ROOMS   = []

do =>
  rooms = process.env.FORUM_POLL_ANNOUNCE_ROOMS || process.env.HUBOT_IRC_ROOMS || ''
  ANNOUNCE_ROOMS = rooms.split ','

# Polling system

class SOPoller
  HOST_URL    = 'http://api.stackexchange.com'
  API_URI     = '/2.2/questions'

  constructor: (@robot, @poster) ->
    @poster  ||= new ThreadPoster(@robot)
    @poller    = new Poller(@robot.http(HOST_URL+API_URI).query(
      site:   "stackoverflow"
      order:  "desc"
      sort:   "activity"
      tagged: "octobercms"
      filter: "default"
    ), POLL_INTERVAL)
    @recentIds = []

  pollForNewThreads: ->
    @poller.start (res) => @newThreadsCallback.call(this, res.items)

  stop: ->
    @poller.stop()

  fetchNewThreads: ->
    @poller.fetch().then (res) =>
      @newThreadsCallback.call(this, res.items)

  newThreadsCallback: (threads) ->
    newThreads = threads.filter (thread) => @threadIsNew(thread)
    if newThreads.length > 0
      @poster.postNewThreads(newThreads.slice(0, 3))
    else
      console.log "No new posts from fetch at ", new Date()

  threadIsNew: (thread) ->
    return false unless @recentIds.indexOf(thread.question_id) is -1

    @recentIds.shift() if @recentIds.length is 5
    @recentIds.push(thread.question_id)
    true

class NoticeCreator
  MESSAGE_FORMAT = "StackOverflow: :subject :url"

  truncate: (msg, length = 50) ->
    if msg.length > length then msg.substring(0, length) + '...' else msg

  create: (thread) ->
    message = MESSAGE_FORMAT
    message = message.replace(':subject', @truncate(thread.title))
                     .replace(':url', thread.link)
    message

class ThreadPoster
  constructor: (@robot) ->
    @notice = new NoticeCreator()

  postNewThreads: (threads) ->
    if threads? and threads.length > 0
      messages = (@notice.create(thread) for thread in threads)
      ANNOUNCE_ROOMS.forEach (room) => @robot.messageRoom room, messages.join("\r\n")

module.exports = (robot) ->
  poller = new SOPoller(robot)

  # Start polling
  poller.pollForNewThreads()

  # Manual trigger
  robot.respond /check stackoverflow/i, (msg) ->
    poller.fetchNewThreads()
