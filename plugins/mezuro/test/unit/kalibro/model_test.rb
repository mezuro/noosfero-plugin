require "test_helper"

class ModelTest < ActiveSupport::TestCase

  def setup
    @model = Kalibro::Model.new({})
    @client = Object.new
    @response = Object.new
    @not_model = Object.new
    @another_model = Kalibro::Model.new({})
    @exception = Exception.new
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

  should 'not exist id 0' do
    Kalibro::Model.expects(:request).
      with(:model_exists,{:model_id=>0}).returns({:exists => false})
    assert !Kalibro::Model.exists?(0)
  end

  should 'exist id 42' do
    Kalibro::Model.expects(:request).
      with(:model_exists,{:model_id=>42}).returns({:exists=>true})
    assert Kalibro::Model.exists?(42)
  end

  should 'not find id 0' do
    Kalibro::Model.expects(:exists?).with(0).returns(false)
    begin
      @model = Kalibro::Model.find 0
      assert false
    rescue Kalibro::Errors::RecordNotFound
      assert true
    end
  end

  should 'find id 42' do
    Kalibro::Model.expects(:exists?).with(42).returns(true)
    Kalibro::Model.expects(:request).
      with(:get_model,{:model_id => 42}).
      returns({:model => {}})
    model = Kalibro::Model.find 42
    assert model == @model
  end

  should 'be succesfully destroyed' do
    Kalibro::Model.expects(:request).with(:delete_model,{:model_id => @model.id})
    @model.destroy
    assert @model.errors.empty?
  end

  should 'fail to be destroyed' do
    Kalibro::Model.expects(:request).
      with(:delete_model,{:model_id => @model.id}).
      raises(@exception)
    @model.destroy
    assert @model.errors.include?(@exception)
  end

end
