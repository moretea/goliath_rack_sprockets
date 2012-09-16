require 'sprockets'
require 'goliath/rack/sprockets/version'

module Goliath
  module Rack
    class Sprockets

      def initialize(app, options)
        @app     = app
        @options = options

        @options[:root]     ||= Goliath::Application.root_path
        @options[:url_path] ||= "/assets/"

        if not @options.has_key?(:asset_paths)
          raise ArgumentError.new("You should pass the :asset_paths option")
        end

        if @options[:asset_paths].nil? || @options[:asset_paths].empty?
          raise ArgumentError.new("The :asset_paths option is invalid")
        end
      end

      def call(env)
        if (asset_path = env['REQUEST_PATH']).start_with?(@options[:url_path])
          logical_name = File.basename(asset_path)

          # Build sprockets environment
          environment = ::Sprockets::Environment.new(@options[:root])
          @options[:asset_paths].each do |asset_path|
            environment.append_path asset_path
          end

          # Lookup the asset
          asset = environment[logical_name]

          if asset
            [200, {
              'Content-Type' => asset.content_type,
              'Last-Modified' => asset.mtime,
              'ETag' => asset.digest
            }, asset.to_s]
          else
            [404, {}, "No such asset (#{logical_name}) found"]
          end
        else
          @app.call(env)
        end
      end
    end
  end
end
