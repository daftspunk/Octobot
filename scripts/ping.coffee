# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   hubot ping - Reply with pong
#   hubot echo <text> - Reply back with <text>
#   hubot time - Reply with current time
#   hubot die - Pretend to end hubot process

module.exports = (robot) ->
  robot.respond /PING$/i, (msg) ->
    msg.send "PONG"

  robot.respond /ECHO (.*)$/i, (msg) ->
    msg.send msg.match[1]

  robot.respond /TIME$/i, (msg) ->
    msg.send "Server time is: #{new Date()}"

  robot.respond /DIE$/i, (msg) ->
    msg.send "Goodbye, cruel world."

  robot.hear /(([^:\s!]+):\s)(can (I ask )?you (help|something))/i, (msg) ->
    msg.send "Please avoid directing questions at specific people, ask the room instead."

  robot.hear /(.+)?(is( there)?|are|can)?(you|((some|any)(one|body))) (awake|alive|help( me)?|home|(in|out )?t?here)(\?)?$/i, (msg) ->
    msg.send "Probably! What do you want to know?"

  robot.hear /^(?:([^:\s!]+):\s)?(?:(?:(?:do|have)? you )|(?:does|has)?\s?anyone )?(?:got|have)(?: (time|a minute))( to help)?\??/i, (msg) ->
    user = msg.match[1]
    type = msg.match[2]

    if type is "time"
      msg.send "So much universe, and so little time..."
    else
      msg.send "There is always time for another last minute"
