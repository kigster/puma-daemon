# frozen_string_literal: true

run ->(_env) { [200, { 'Content-Type' => 'text/plain' }, ['Hello World']] }
