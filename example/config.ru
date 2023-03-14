# frozen_string_literal: true

# config.ru
run(proc { |*| ['200', { 'Content-Type' => 'text/html' }, ['Hello World']] })
# run this with rackup command
