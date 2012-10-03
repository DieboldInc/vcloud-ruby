require 'spec_helper'

include WebMock::API

describe VCloud::RestApi do
  describe 'when receiving an HTTP error code' do
    it 'should handle a HTTP 401 error when logging in with a bad password' do
      stub_request(:post, "https://someuser%40someorg:badpassword@some.vcloud.com/api/sessions").
               with(:headers => {'Accept'=>'application/*+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
               to_return(:status => 401, :body => "", :headers => {})
               
      session = VCloud::Client.new('https://some.vcloud.com/api/', '1.5')             
      expect { session.login('someuser@someorg', 'badpassword') }.to raise_error(VCloud::VCloudError) { |error| 
        error.major_error_code.should == 401
      }
    end
    
    it 'should handle a HTTP 403 error when logging out with a bad token' do             
      stub_request(:post, "https://someuser%40someorg:password@some.vcloud.com/api/sessions").
               with(:headers => {'Accept'=>'application/*+xml;version=1.5'}).
               to_return(:status => 200, :body => fixture_file('session.xml'), :headers => {:x_vcloud_authorization => "abc123xyz"})
      
      session = VCloud::Client.new('https://some.vcloud.com/api/', '1.5')
      session.login('someuser@someorg', 'password')    
      
      stub_request(:delete, "https://some.vcloud.com/api/session").
        with(:headers => {'Accept'=>'application/*+xml;version=1.5', 'X-Vcloud-Authorization'=>'bad token'}).
        to_return(:status => 403, :body => "", :headers => {})
      
      session.token[:x_vcloud_authorization] = "bad token" 
      expect { session.logout }.to raise_error(VCloud::VCloudError) { |error| 
        error.major_error_code.should == 403
      }
    end
    
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