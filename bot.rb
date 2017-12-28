require 'socket'

TWITCH_HOST = 'irc.twitch.tv'
TWITCH_PORT = 6667

class TwitchBot

  def initialize
    @nickname = "kFrogBot"
    @password = ""
    @channel = "kthefrog"
    @socket = TCPSocket.open(TWITCH_HOST, TWITCH_PORT)

    writeToSystem "PASS #{@password}"
    writeToSystem "NICK #{@nickname}"
    writeToSystem "USER #{@nickname} 0 * #{@nickname}"
    writeToSystem "JOIN ##{@channel}"

  end

  def writeToSystem(message)
    @socket.puts message
  end

  def writeToChat(message)
    writeToSystem "PRIVMSG ##{@channel} : #{message}"
  end

  def run

    writeToChat "kFrogBot jumped in the Frog Pond!"

    until @socket.eof? do
      message = @socket.gets
      puts message

      if message.match(/^PING :(.*)$/)
        writeToSystem "PONG #{$~[1]}"
        next
      end

      if message.match(/PRIVMSG ##{@channel} :(.*)$/)
        content = $~[1]
        username = message.match(/@(.*).tmi.twitch.tv/)[1]

        if content.include? "!help"
          writeToChat "Sorry but I have no commands set up yet =("
        end

      end
    end
  end

  def quit
    writeToChat "kFrog Bot is hopping out!"
    writeToSystem "PART ##{@channel}"
    writeToSystem "QUIT"
  end

end

bot = TwitchBot.new
trap("INT") {bot.quit}
bot.run
