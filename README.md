# Wisper::ActiveRecord

[![Build Status](https://travis-ci.org/krisleech/wisper-activerecord.png?branch=master)](https://travis-ci.org/krisleech/wisper-activerecord)

Transparently publish model lifecycle events to subscribers.

Using Wisper events is a better alternative to ActiveRecord callbacks and Observers.

Listeners are subscribed to models at runtime.

## Installation

```ruby
gem 'wisper-activerecord'
```

## Usage

### Setup a publisher

```ruby
class Meeting < ActiveRecord::Base
  include Wisper.model

  # ...
end
```

If you wish all models to broadcast events without having to explicitly include
`Wisper.model` add the following to an initializer:

```ruby
Wisper::ActiveRecord.extend_all
```

### Subscribing

Subscribe a listener to model instances:

```ruby
meeting = Meeting.new
meeting.subscribe(Auditor.new)
```

Subscribe a block to model instances:

```ruby
meeting.on(:create_meeting_successful) { |meeting| ... }
```

Subscribe a listener to _all_ instances of a model:

```ruby
Meeting.subscribe(Auditor.new)
```

Please refer to the [Wisper README](https://github.com/krisleech/wisper) for full details about subscribing.

The events which are automatically broadcast are:

* `before_{create, update, destroy}`
* `after_{create, update, destroy}`

### Reacting to Events

To receive an event the listener must implement a method matching the name of
the event with a single argument, the instance of the model.

```ruby
def create_meeting_successful(meeting)
  # ...
end
```

### Success and Failure Events for Create and Update

To have events broadcast for success and failure of create and
update you must use the `commit` method.

```ruby
meeting.title = 'My Meeting'
meeting.commit
```

You can also pass attributes directly to `commit`:

```ruby
meeting.commit(title: 'My Meeting')
```

And use the class method for creating new records:

```ruby
Meeting.commit(title: 'My Meeting')
```

In addition the the regular events broadcast the following events are also broadcast:

* `{create, update}_<model_name>_{successful, failed}`

## Example

### Controller

```ruby
class MeetingsController < ApplicationController
  def new
    @meeting = Meeting.new
  end

  def create
    @meeting = Meeting.new(params[:meeting])
    @meeting.subscribe(Auditor.instance)
    @meeting.on(:meeting_create_successful) { redirect_to meeting_path }
    @meeting.on(:meeting_create_failed)     { render action: :new }
    @meeting.commit
  end

  def edit
    @meeting = Meeting.find(params[:id])
  end

  def update
    @meeting = Meeting.find(params[:id])
    @meeting.subscribe(Auditor.instance)
    @meeting.on(:meeting_update_successful) { redirect_to meeting_path }
    @meeting.on(:meeting_update_failed)     { render :action => :edit }
    @meeting.commit(params[:meeting])
  end
end
```

### Listener

**Which simply records an audit in memory**

```ruby
class Auditor
  include Singleton

  attr_accessor :audit

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
Meeting.create(:description => 'Team Retrospective', :starts_at => Time.now + 2.days)

meeting = Meeting.find(1)
meeting.starts_at = Time.now + 2.months
meeting.save
```

**And check the audit**

```ruby
Auditor.audit # => [...]
```

## Compatibility

Tested on 1.9.3, 2.x, Rubinius and JRuby for ActiveRecord ~> 3.0 and ~> 4.0

See the CI [build status](https://travis-ci.org/krisleech/wisper-activerecord) for more information.

## Contributing

Please submit a Pull Request with specs.

### Running the specs

```
bundle exec rspec
```
