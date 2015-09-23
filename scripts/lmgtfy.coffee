# Description:
#   Tell Octobot to send a user a link to lmgtfy.com
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   [o_B]: lmgtfy <optional @username> <some query>
#

module.exports = (robot) ->
   robot.respond /lmgtfy?\s?(?:@(\w*))? (.*)/i, (msg) ->
     link = ""
     link += "#{msg.match[1]}: " if msg.match[1]
     link += "http://lmgtfy.com/?q=#{escape(msg.match[2])}"
     msg.send link
