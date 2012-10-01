require 'spec_helper'

include WebMock::API

describe VCloud::Task do
  describe 'when parsing #from_xml' do
    before(:each) do
      @task = VCloud::Task.from_xml(fixture_file('task.xml'))
    end

    it 'should have correct values' do
      @task.name.should == 'task'
      @task.id.should == 'urn:vcloud:task:5acdbbab-0496-4a57-bf81-cec0be0ae8fb'
      @task.type.should == 'application/vnd.vmware.vcloud.task+xml'
      @task.href.should == "https://vcloud.com/api/task/5acdbbab-0496-4a57-bf81-cec0be0ae8fb"
      @task.status.should == 'running'
      @task.start_time.should == '2012-10-01T15:31:10.175-04:00'
      @task.operation_name.should == 'vappUndeployPowerOff'
      @task.operation.should == 'Stopping Virtual Application (6e2ec079-c533-4d99-8f29-2a90ba18da87)'
      @task.expiry_time.should == '2012-12-30T15:31:10.175-05:00'
    end
  end
 
  describe 'when #wait_to_finish' do
    before(:each) do
      @task = VCloud::Task.from_xml(fixture_file('task.xml'))
      @task.session = @session
    end
    
    it 'should timeout' do
      stub_request(:get, 'https://vcloud.com/api/task/5acdbbab-0496-4a57-bf81-cec0be0ae8fb').
        with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.task+xml;version=1.5', 'X-Vcloud-Authorization'=>'abc123xyz'}).
        to_return(:status => 200, :body => fixture_file('task.xml'))
      
      lambda {@task.wait_to_finish(5)}.should raise_error(Timeout::Error)
    end     
    
    it "should consider 'success' complete" do
      stub_request(:get, 'https://vcloud.com/api/task/5acdbbab-0496-4a57-bf81-cec0be0ae8fb').
        with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.task+xml;version=1.5', 'X-Vcloud-Authorization'=>'abc123xyz'}).
        to_return(:status => 200, :body => lambda{|request| t=VCloud::Task.new;t.status='success';t.to_xml})
        
       lambda {@task.wait_to_finish(54)}.should_not raise_error(Timeout::Error)
       @task.status.should == 'success'      
    end
    
    it "should consider 'error' complete" do
      stub_request(:get, 'https://vcloud.com/api/task/5acdbbab-0496-4a57-bf81-cec0be0ae8fb').
        with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.task+xml;version=1.5', 'X-Vcloud-Authorization'=>'abc123xyz'}).
        to_return(:status => 200, :body => lambda{|request| t=VCloud::Task.new;t.status='error';t.to_xml})
        
       lambda {@task.wait_to_finish(54)}.should_not raise_error(Timeout::Error)
       @task.status.should == 'error'      
    end

    it "should consider 'canceled' complete" do
      stub_request(:get, 'https://vcloud.com/api/task/5acdbbab-0496-4a57-bf81-cec0be0ae8fb').
        with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.task+xml;version=1.5', 'X-Vcloud-Authorization'=>'abc123xyz'}).
        to_return(:status => 200, :body => lambda{|request| t=VCloud::Task.new;t.status='canceled';t.to_xml})
        
       lambda {@task.wait_to_finish(54)}.should_not raise_error(Timeout::Error)
       @task.status.should == 'canceled'      
    end    
      
    it "should consider 'aborted' complete" do
      stub_request(:get, 'https://vcloud.com/api/task/5acdbbab-0496-4a57-bf81-cec0be0ae8fb').
        with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.task+xml;version=1.5', 'X-Vcloud-Authorization'=>'abc123xyz'}).
        to_return(:status => 200, :body => lambda{|request| t=VCloud::Task.new;t.status='aborted';t.to_xml})
        
       lambda {@task.wait_to_finish(54)}.should_not raise_error(Timeout::Error)
       @task.status.should == 'aborted'      
    end
  end
end