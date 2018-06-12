describe 'ActiveRecord' do
  let(:listener)    { double('Listener') }
  let(:model_class) { Class.new(Meeting) { include Wisper.model } }

  before { Wisper::GlobalListeners.clear }
  before { allow(model_class).to receive(:name).and_return('Meeting') }

  it '.model returns ActiveRecord module' do
    expect(Wisper.model).to eq Wisper::ActiveRecord::Publisher
  end

  describe 'validation' do
    it 'publishes an before_validation event to listener' do
      expect(listener).to receive(:before_validation).with(instance_of(model_class))
      expect(listener).to receive(:before_meeting_validated).with(instance_of(model_class))
      model_class.subscribe(listener)
      model_class.create
    end
    it 'publishes an after_validation event to listener' do
      expect(listener).to receive(:after_validation).with(instance_of(model_class))
      expect(listener).to receive(:after_meeting_validated).with(instance_of(model_class))
      model_class.subscribe(listener)
      model_class.create
    end
  end

  describe 'create' do
    it 'publishes an before_create event to listener' do
      expect(listener).to receive(:before_create).with(instance_of(model_class))
      expect(listener).to receive(:before_meeting_created).with(instance_of(model_class))
      model_class.subscribe(listener)
      model_class.create
    end
    it 'publishes an after_create event to listener' do
      expect(listener).to receive(:after_create).with(instance_of(model_class))
      expect(listener).to receive(:after_meeting_created).with(instance_of(model_class))
      model_class.subscribe(listener)
      model_class.create
    end
  end

  describe 'update' do
    before { model_class.create! }

    let(:model) { model_class.first }

    it 'publishes an before_update event to listener' do
      expect(listener).to receive(:before_update).with(instance_of(model_class))
      expect(listener).to receive(:before_meeting_updated).with(instance_of(model_class))
      model.subscribe(listener)
      model.update(title: 'new title')
    end

    it 'publishes an after_update event to listener' do
      expect(listener).to receive(:after_update).with(instance_of(model_class))
      expect(listener).to receive(:after_meeting_updated).with(instance_of(model_class))
      model.subscribe(listener)
      model.update(title: 'new title')
    end
  end

  describe 'destroy' do
    before { model_class.create! }

    let(:model) { model_class.first }

    it 'publishes an before_destroy event to listener' do
      expect(listener).to receive(:before_destroy).with(instance_of(model_class))
      expect(listener).to receive(:before_meeting_destroyed).with(instance_of(model_class))
      model_class.subscribe(listener)
      model.destroy
    end

    it 'publishes an after_destroy event to listener' do
      expect(listener).to receive(:after_destroy).with(instance_of(model_class))
      expect(listener).to receive(:after_meeting_destroyed).with(instance_of(model_class))
      model_class.subscribe(listener)
      model.destroy
    end
  end

  describe 'commit' do
    it 'publishes an after_commit event to listener' do
      expect(listener).to receive(:after_commit).with(instance_of(model_class))
      expect(listener).to receive(:after_meeting_committed).with(instance_of(model_class))
      model_class.subscribe(listener)
      model_class.create
    end
  end

  describe 'rollback' do
    it 'publishes an after_rollback event to listener' do
      expect(listener).to receive(:after_rollback).with(instance_of(model_class))
      expect(listener).to receive(:after_meeting_rolled_back).with(instance_of(model_class))
      model_class.subscribe(listener)
      model_class.transaction do
        model_class.create!
        raise ActiveRecord::Rollback
      end
    end
  end
end
