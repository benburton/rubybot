# A basic interface for specifying interaction between a listener
# and the underlying IRC connection.
class MessageListener
  
  # Regular expressions used to specify whether the listener is
  # valid under a given context. If the message is being sent 
  # from a channel, and it matches the message_regex, 
  attr_accessor :message_regex, :pm_regex
  
  def initialize(irc, message_regex, pm_regex=//)
    @message_regex = message_regex
    @pm_regex = pm_regex
    @irc = irc
  end
  
  # Sends a message to the target (target being an IRC channel or
  # a user to PM).
  def send(target, message)
    @irc.send_msg(target, message)
  end
  
end