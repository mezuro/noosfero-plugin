require "test_helper"

class ModelTest < ActiveSupport::TestCase

  def setup
	@model = Kalibro::Model.new({})
	@client = Object.new
	@response = Object.new
  end

  should 'create model from hash' do
    assert_equal [], @model.errors
  end

  should 'return hash with errors' do
    assert @model.to_hash.empty?
  end

  should 'receive response 42 as a request answer' do
    Kalibro::Model.expects(:client).with(Kalibro::Model.endpoint).returns(@client)
    @client.expects(:request).with(:kalibro, :answer).returns(@response)
    @response.expects(:to_hash).returns({:answer_response => 42})
    assert_equal 42, Kalibro::Model.request(:answer)
  end


end
