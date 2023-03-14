# frozen_string_literal: true

require 'puma/daemon'

# The directory to operate out of.
# The default is the current directory.

# The default is “development”.

environment 'development'

# Store the pid of the server in the file at “path”.

pidfile '/tmp/puma.pid'

# Use “path” as the file to store the server info state. This is
# used by “pumactl” to query and control the server.
state_path '/tmp/puma.state'

# Redirect STDOUT and STDERR to files specified. The 3rd parameter
# (“append”) specifies whether the output is appended, the default is
# “false”.
stdout_redirect '/tmp/puma_access.log', '/tmp/puma_error.log', true

quiet

threads 0, 16

# Bind the server to “url”. “tcp://”, “unix://” and “ssl://” are the only
# accepted protocols.
# The default is “tcp://0.0.0.0:9292”.

bind 'unix:///tmp/puma.sock'
bind 'tcp://0.0.0.0:9292'

# Instead of “bind 'ssl://127.0.0.1:9292?key=path_to_key&cert=path_to_cert'” you
# can also use the “ssl_bind” option.

# ssl_bind '127.0.0.1', '9292', { key: path_to_key, cert: path_to_cert }

# Code to run before doing a restart. This code should
# close log files, database connections, etc.

# This can be called multiple times to add code each time.

on_restart do
  puts 'On restart...'
end

# Command to use to restart puma. This should be just how to
# load puma itself (ie. 'ruby -Ilib bin/puma'), not the arguments
# to puma, as those are the same as the original process.

# === Cluster mode ===

# How many worker processes to run.
# The default is “0”.

workers 2

# Code to run when a worker boots to setup the process before booting
# the app.
# This can be called multiple times to add hooks.

# === Puma control rack application ===

# Start the puma control rack application on “url”. This application can
# be communicated with to control the main server. Additionally, you can
# provide an authentication token, so all requests to the control server
# will need to include that token as a query parameter. This allows for
# simple authentication.

# Check out https://github.com/puma/puma/blob/master/lib/puma/app/status.rb
# to see what the app has available.

# activate_control_app 'unix:///var/run/pumactl.sock'

daemonize
