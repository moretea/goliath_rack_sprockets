require 'spec_helper'
require 'goliath/rack/sprockets'
require 'goliath/goliath'

describe Goliath::Rack::Sprockets do
  let(:app) { mock('app').as_null_object }
  let(:options) { { 
    root: File.expand_path("../../../fixtures", __FILE__),
    asset_paths: ["assets/javascripts", "assets/stylesheets"] 
  } }
  let(:request_path) { "/assets/javascripts/some.js" }

  let(:env) do
    env = Goliath::Env.new
    env['REQUEST_PATH'] = request_path
    env
  end

  subject { Goliath::Rack::Sprockets.new(app, options) }

  it 'accepts an app' do
    lambda { Goliath::Rack::Sprockets.new('my app', options) }.should_not raise_error
  end

  context "illegal configuration" do
    context "empty options" do
      let(:options) { {} }
      it "is not allowed" do
        expect { Goliath::Rack::Sprockets.new(app, options) }.to raise_error
      end
    end

    context "illegal asset path" do
      it "nil is not accepted" do
        options =  { asset_paths: nil}
        expect { Goliath::Rack::Sprockets.new(app, options) }.to raise_error
      end

      it "empty list is not accepted" do
        options =  { asset_paths: [] }
        expect { Goliath::Rack::Sprockets.new(app, options) }.to raise_error
      end
    end
  end

  describe "request chain filtering" do
    context "non asset path" do
      let(:request_path) { "/not/a/asset" }

      it "hands over execution to the next rack middleware" do
        app.should_receive(:call)
        subject.call(env)
      end
    end

    context "asset path" do
      let(:request_path) { "/assets/some_file.js" }

      it "stops the chain" do
        app.should_not_receive(:call)
        subject.call(env)
      end
    end
  end

  describe "asset handling" do
    let(:request_path) { "/assets/awesome.js" }

    it "look up the correct logical file name" do
      ::Sprockets::Environment.any_instance.should_receive(:[]).with("awesome.js")
      subject.call(env)
    end

    context "existence of asset" do
      let(:response)         { subject.call(env) }
      let(:response_status)  { response[0] }
      let(:response_body)    { response[2] }

      context "asset doesn't exist" do
        let(:request_path) { "/assets/does_not_exist.js" }

        it "returns a 404" do
          response_status.should == 404
        end

        it "returns an error message" do
          response_body.should == "No such asset (does_not_exist.js) found"
        end
      end

      context "asset exists" do
        let(:request_path) { "/assets/exists.js" }

        before do
          File.stub(:exists?).and_return true
        end

        it "returns a 200" do
          response_status.should == 200
        end

        it "returns the content of the asset file" do
          response_body.chomp.should == 'alert("I exist");'
        end
      end
    end
  end
end
