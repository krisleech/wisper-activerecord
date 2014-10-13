require "wisper/active_record/version"
require "wisper/active_record/publisher"

module Wisper
  def self.model
    ::Wisper::ActiveRecord::Publisher
  end

  module ActiveRecord
    def self.extend_all
      ::ActiveRecord::Base.class_eval { include Wisper.model }
    end
  end
end
