My 'rubybot' implementation is a VERY basic IRC bot client that I put
together as an exercise to learn how to write code in Ruby.

Example Usage
======

This example demonstrates a few basic pieces of functionality related
to the bot. You can connect, join channels, add MessageListeners (see
related code), leave channels, and disconnect.
	
	# Import lib for Karma example MessageListener
	require 'irc'
	require 'karma'

	# Creates a new instance of the bot that connects
	# to the provided server and port, using the specified
	# nick and with output turned off
	irc = IRC.new('irc.freenode.net', 6667, 'rubybot', false)
	
	# Join a channel
	irc.join('#test')

	# Add a MessageListener
	irc.add_listener(Karma.new(irc))
	
	# Leave a channel
	irc.part('#test')

	# Disconnect
	irc.disconnect()
