require 'message_listener'

# A simple MessageListener implementation that keeps track of how often
# users upvote or downvote a keyword based based on ~keyword++ and
# ~keyword-- conventions.
class Karma < MessageListener
  
  def initialize(irc)
    super(irc, /~([^!]+)\+\+|~([^!]+)\-\-/)
    @values = {}
  end
  
  # Changes the keyword value and reports the result back
  # to the channel from which the message came
  def receive_message(sender, channel, message)
    if /~([^!]+)\+\+/.match(message)
      send(channel, "#{$1} has a karma level of #{increment($1)}")
    elsif /~([^!]+)\-\-/.match(message)
      send(channel, "#{$1} has a karma level of #{decrement($1)}")
    end
  end
  
  # Increments the value of the provided keyword and
  # returns the modified value
  private
  def increment(key)
    if @values.has_key?(key)
      @values[key] = @values[key] + 1
    else
      @values[key] = 1
    end
    return @values[key]
  end
  
  # Decrements the value of the provided keyword and
  # returns the modified value
  private
  def decrement(key)
    if @values.has_key?(key)
      @values[key] = @values[key] - 1
    else
      @values[key] = -1
    end
    return @values[key]
  end
  
end