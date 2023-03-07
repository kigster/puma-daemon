# config.ru
run Proc.new { |_env| ['200', {'Content-Type' => 'text/html'}, ['Hello World']] }
# run this with rackup command
