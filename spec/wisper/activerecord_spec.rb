describe 'ActiveRecord' do
  let(:listener)    { double('Listener') }
  let(:model_class) { Class.new(Meeting) { include Wisper.model } }

  before { Wisper::GlobalListeners.clear }
  before { allow(model_class).to receive(:name).and_return('Meeting') }

  it '.model returns ActiveRecord module' do
    expect(Wisper.model).to eq Wisper::ActiveRecord::Publisher
  end

  describe 'create' do
    it 'publishes an after_create event to listener' do
      expect(listener).to receive(:after_create).with(instance_of(model_class))
      model_class.subscribe(listener)
      model_class.create
    end
  end

  describe 'update' do
    before { model_class.create! }

    let(:model) { model_class.first }

    it 'publishes an after_update event to listener' do
      expect(listener).to receive(:after_update).with(instance_of(model_class))
      model.subscribe(listener)
      model.update_attributes(title: 'new title')
    end
  end

  describe 'destroy' do
    before { model_class.create! }

    let(:model) { model_class.first }

    it 'publishes an after_destroy event to listener' do
      expect(listener).to receive(:after_destroy).with(instance_of(model_class))
      model_class.subscribe(listener)
      model.destroy
    end
  end

  describe 'commit' do
    after do
      model_class.subscribe(listener)
      model_class.create
    end

    it 'publishes an after_commit event to listener' do
      expect(listener).to receive(:after_commit).with(instance_of(model_class))
    end

    it 'publishes a <model_name>_committed event to listener' do
      expect(listener).to receive(:meeting_committed).with(instance_of(model_class))
    end
  end

  describe 'rollback' do
    it 'publishes an after_rollback event to listener' do
      expect(listener).to receive(:after_rollback).with(instance_of(model_class))
      model_class.subscribe(listener)
      model_class.transaction do
        model_class.create!
        raise ActiveRecord::Rollback
      end
    end
  end
end
