require 'socket'

# Basic low-level implementation of IRC protocol. Handles connection,
# pinging, username management, and input/output redirection.
class IRC
  
  @connected = false
  
  def initialize(server, port=6667, nick='rubybot', verbose=true)
    @server = server
    @port = port
    @nick = nick
    @verbose = verbose
    @listeners = Array.new
    connect()
  end
  
  # Connects to the server.
  def connect()
    if (!@connected)
      @socket = TCPSocket.new(@server, @port)
      @connected = true
      send "USER rubybot rubybot rubybot RubyBot"
      set_nick(@nick)
      if @verbose
        while @connected do
          receive(@socket.gets.to_s.strip)
        end
      end
    else
      raise "Attempting to connect an already-connected IRC client instance."
    end
  end
  
  # Disconnects from the server.
  def disconnect()
    send "QUIT leaving"
    @connected = false
  end
  
  # Adds a new MessageListener.
  def add_listener(listener)
    @listeners << listener
  end
  
  # Join the specified channel.
  def join(channel)
    send "JOIN #{channel}"
  end
  
  # Part the specified channel.
  def part(channel)
    send "PART #{channel}"
  end
  
  # Set the bot's nickname to the provided value.
  def set_nick(nick)
    @nick = nick
    send "NICK #{@nick}"
  end
  
  # Sends a message.
  def send_msg(target, message)
    send "PRIVMSG #{target} :#{message}"
  end
  
  # Triggered when a private message is received. This method
  # notifies all relevant listeners of the PM.
  def receive_pm(sender, message)
    @listeners.each { |listener| 
      if listener.pm_regex.match(message)
        listener.receive_pm(sender, message)
      end
    }
  end
  
  # Triggered when a message has been entered in the channel. This
  # method notifies all relevant listeners of the message.
  def receive_message(sender, channel, message)
    @listeners.each { |listener| 
      if listener.message_regex.match(message)
        listener.receive_message(sender, channel, message) 
      end
    }
  end
  
  # Writes a message to the output console and the IRC socket.
  private
  def send(message)
    puts ">> #{message.strip}"
    @socket.puts(message)
  end
  
  # Called when a message has been received from the IRC socket.
  # Writes the message to the output console, redirects to appropriate
  # methods, and handles errors.
  private
  def receive(message)
    puts "<< #{message.strip}"
    # Handling pings
    if /^PING :(.+)$/i.match(message)
      send("PONG :#{$1}")
    end
    
    #Handle situation in which nick is already taken
    if message.include?("Nickname is already in use.")
      set_nick(@nick + "_")
    end
    if /:([^!]+)!([^@]+)@(\S+) PRIVMSG (\S+) :(.+)/.match(message)
      on_message($1, $2, $3, $4, $5)
    end
  end
  
  # Method called when data received from the server is a message coming
  # from either a channel or a private message.
  private
  def on_message(nick, user, hostname, channel, message)
    if (@nick == channel)
      receive_pm(nick, message)
    else
      receive_message(nick, channel, message)
    end
  end
  
end
