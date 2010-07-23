# encoding: UTF-8

unless defined? Hammer
  require 'pp'
  #  require 'uuid'
  require 'active_support/core_ext'
  require 'active_support/basic_object'
  require 'erector'
  require 'sinatra/base'
  require 'em-websocket'
  require 'configliere'
  require 'json/pure' # TODO require something faster
  require 'benchmark'
  require 'neverblock'
  require 'hammer/config'
  #  require 'weakref'

  module Hammer

    include Hammer::Config

    def self.logger
      @logger ||= Hammer::Logger.new(config[:logger][:output])
    end

    def self.v19?
      RUBY_VERSION =~ /1.9/
    end

    def self.benchmark(label, req = true, &block)
      time = Benchmark.realtime { block.call }
      Hammer.logger.info "#{label} in %0.6f sec" % time unless req
      Hammer.logger.info "#{label} in %0.6f sec ~ %d req" % [time, (1/time).to_i] if req
    end

  end

  require 'hammer/loader.rb'

  # require 'datamapper'
  # require "#{Hammer.root}/lib/setup_db.rb"
  # DataMapper.setup(:default, 'sqlite3://memory')
  # DataMapper.auto_migrate!
end
