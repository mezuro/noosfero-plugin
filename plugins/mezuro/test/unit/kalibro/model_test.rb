require "test_helper"

class ModelTest < ActiveSupport::TestCase

  def setup
	@model = Kalibro::Model.new({})
	@client = Object.new
	@response = Object.new
	@not_model = Object.new
	@another_model = Kalibro::Model.new({})
  end

  should 'create model from hash' do
    assert_equal [], @model.errors
  end

  should 'create empty hash' do
    assert @model.to_hash.empty?
  end

  should 'receive response 42 as a request answer' do
    Kalibro::Model.expects(:client).with(Kalibro::Model.endpoint).returns(@client)
    @client.expects(:request).with(:kalibro, :answer).returns(@response)
    @response.expects(:to_hash).returns({:answer_response => 42})
    assert_equal 42, Kalibro::Model.request(:answer)
  end

  should 'convert to oject' do
	assert_equal @model, Kalibro::Model.to_object({})
    assert_equal 42, Kalibro::Model.to_object(42)
  end

  should 'convert to object array' do
    assert_equal [42, :answer], Kalibro::Model.to_objects_array([42, :answer])
    assert_equal [1337], Kalibro::Model.to_objects_array(1337)
  end

  should 'should save class id' do
    Kalibro::Model.expects(:request).with(:save_model, {:model=>{}}).returns({:model_id => 42})
    assert_equal false, @model.save
    assert_equal NoMethodError, @model.errors[0].class
  end

  should 'create and save a model' do
    attributes = {}
    Kalibro::Model.expects(:new).with(attributes).returns(@model)
	@model.expects(:save)
	assert_equal @model, Kalibro::Model.create(attributes)
  end

  should 'be different because of their classes' do
    assert !(@model == @not_model)
  end

  should 'be different because of the value of theirs variables' do
	@model.expects(:variable_names).returns(["answer"])
	@model.expects(:send).with("answer").returns(42)
	@another_model.expects(:send).with("answer").returns("macaco")
	assert !(@model == @another_model)
  end

  should 'be equal because they are both empty' do
    assert (@model == @another_model)
  end

  should 'be equal because of the value of theirs variables' do
	@model.expects(:variable_names).returns(["answer"])
	@model.expects(:send).with("answer").returns(42)
	@another_model.expects(:send).with("answer").returns(42)
	assert (@model == @another_model)
  end

end
