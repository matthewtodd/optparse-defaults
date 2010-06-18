require 'optparse'

class OptionParser
  module Defaults
    VERSION = '0.1.0'

    def defaults=(defaults)
      @defaults = defaults.extend(Arguments)
    end

    # Note that it's important to use #order rather than #permute, to ensure
    # that the given options have a chance to override the defaults. (These are
    # <tt>POSIX</tt>-ly correct semantics.)
    def order(*args, &block)
      super(*@defaults.followed_by(*args), &block)
    rescue ParseError
      abort($!)
    end

    def help
      @defaults.help(super, summary_indent)
    end

    private

    module Arguments #:nodoc:
      def followed_by(*args)
        dup.concat(args.flatten)
      end

      def help(before, indent)
        "#{before}\nDefaults:\n#{indent}#{join ' '}"
      end
    end
  end

  def self.with_defaults(*args)
    new(*args) do |instance|
      instance.extend(Defaults)
      yield instance if block_given?
    end
  end
end
