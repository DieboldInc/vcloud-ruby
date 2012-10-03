require 'spec_helper'

include WebMock::API

describe VCloud::RestApi do
  describe 'when receiving an HTTP error code' do
    it 'should handle a HTTP 404 error when logging in with a bad API endpoint' do
      stub_request(:post, "https://someuser%40someorg:password@some.vcloud.com/badapiendpoint/sessions").
               with(:headers => {'Accept'=>'application/*+xml;version=1.5'}).
               to_return(:status => 404, :body => fixture_file('error_login_404.html'), :headers => {})
               
      session = VCloud::Client.new('https://some.vcloud.com/badapiendpoint/', '1.5')             
      
      expect { session.login('someuser@someorg', 'password') }.to raise_error(VCloud::VCloudError) { |error| 
        error.major_error_code.should == 404
      }
    end
  end
end