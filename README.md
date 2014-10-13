# Wisper::ActiveRecord [WIP]

[![Build Status](https://travis-ci.org/krisleech/wisper-activerecord.png?branch=master)](https://travis-ci.org/krisleech/wisper-activerecord)

Transparently publish model lifecycle to subscribers.

## Installation

```ruby
gem 'wisper-activerecord'
```

## Usage

### The Model

```ruby
class Meeting < ActiveRecord::Base
  include Wisper.model

  # ...
end
```

If you wish all models to broadcast events without having explicitly include
`Wisper.model` in each you can add the following to an initializer:

```ruby
# config/initializers/wisper.rb
Wisper::ActiveRecord.extend_all
```

#### Subscribing Listeners

We can now subscribe a listener to instances of models:

```ruby
meeting = Meeting.new
meeting.subscribe(Auditor.new)
```

Or if we prefer we can subscribe a listener to all instance of a model:

```ruby
Meeting.subscribe(Auditor.new)
```

Please refer to the Wisper gem for full details about subscribing.

The events broadcast are:

* before_{create, update, destroy}
* create_<model_name>_successful
* create_<model_name>_failed
* update_<model_name>_successful
* update_<model_name>_failed
* destroy<model_name>_successful
* destroy<model_name>_failed
* after{create, update, destroy}

### Subscribing blocks

```ruby
meeting.on(:create_meeting_successful) { |meeting| ... }
```

### The Listener

To receive an event the listener must implement a method matching the name of
the event with a single argument, the instance of the model.

#### An example Listener

**Which simply logs all events in memory**

```ruby
class Auditor
  include Singleton

  attr_accessor :audt

  def initialize
    @audit = []
  end

  def after_create(subject)
    push_audit_for('create', subject)
  end

  def after_update(subject)
    push_audit_for('update', subject)
  end

  def after_destroy(subject)
    push_audit_for('destroy', subject)
  end

  def self.audit
    instance.audit
  end

  private

  def push_audit_for(action, subject)
    audit.push(audit_for(action, subject))
  end

  def audit_for(action, subject)
    {
      action: action,
      subject_id: subject.id,
      subject_class: subject.class.to_s,
      changes: subject.changes,
      created_at: Time.now
    }
  end
end
```

**Do some CRUD**

```ruby
Meeting.create(:description => ‘Team Retrospective’, :starts_at => Time.now + 2.days)

meeting = Meeting.find(1)
meeting.starts_at = Time.now + 2.months
meeting.save
```

**And check the audit**

```ruby
Auditor.audit # => [...]
```

## Contributing

Please submit a Pull Request with specs.

### Running the specs

```
bundle exec rspec
```
