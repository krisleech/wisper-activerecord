# Wisper::ActiveRecord

[![Gem Version](https://badge.fury.io/rb/wisper-activerecord.png)](http://badge.fury.io/rb/wisper-activerecord)
[![Code Climate](https://codeclimate.com/github/krisleech/wisper-activerecord.png)](https://codeclimate.com/github/krisleech/wisper-activerecord)
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

* `before_validation`
* `before_<model_name>_validated`
* `before_create`
* `before_<model_name>_created`
* `before_update`
* `before_<model_name>_updated`
* `before_destroy`
* `before_<model_name>_destroyed`
* `before_save`
* `before_<model_name>_saved`
* `after_validation`
* `validate_<model_name>_failed`
* `after_<model_name>_validated`
* `after_create`
* `create_<model_name>_{successful, failed}`
* `after_<model_name>_created`
* `after_update`
* `update_<model_name>_{successful, failed}`
* `after_<model_name>_updated`
* `after_destroy`
* `after_<model_name>_destroyed`
* `after_save`
* `after_<model_name>_saved`
* `after_commit`
* `after_<model_name>_committed`
* `after_rollback`
* `after_<model_name>_rolled_back`


### Reacting to Events

To receive an event the listener must implement a method matching the name of
the event with a single argument, the instance of the model.

```ruby
def create_meeting_successful(meeting)
  # ...
end
```

## Example

### Controller

```ruby
class MeetingsController < ApplicationController
  def new
    @meeting = Meeting.new
  end

  def create
    @meeting = Meeting.new(params[:meeting])
    @meeting.subscribe(Auditor.new)
    @meeting.on(:create_meeting_successful) { redirect_to meeting_path }
    @meeting.on(:create_meeting_failed)     { render action: :new }
    @meeting.save
  end

  def edit
    @meeting = Meeting.find(params[:id])
  end

  def update
    @meeting = Meeting.find(params[:id])
    @meeting.subscribe(Auditor.new)
    @meeting.on(:update_meeting_successful) { redirect_to meeting_path }
    @meeting.on(:update_meeting_failed)     { render :action => :edit }
    @meeting.update_attributes(params[:meeting])
  end
end
```

Using `on` to subscribe a block to handle the response is optional,
you can still use `if @meeting.save` if you prefer.

### Listener

**Which simply records an audit in memory**

```ruby
class Auditor

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
    @audit ||= []
  end

  private

  def push_audit_for(action, subject)
    self.class.audit.push(audit_for(action, subject))
  end

  def audit_for(action, subject)
    {
      action: action,
      subject_id: subject.id,
      subject_class: subject.class.to_s,
      changes: subject.previous_changes,
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

## Notes on Testing 

### ActiveRecord <= 4.0

This gem makes use of ActiveRecord's `after_commit` lifecycle hook to broadcast
events, which will create issues when testing with transactional fixtures.
Unless you also include the [test_after_commit gem](https://github.com/grosser/test_after_commit)
ActiveRecord models will not broadcast any lifecycle events within your tests.

## Compatibility

Tested on CRuby, Rubinius and JRuby for ActiveRecord ~> 3.0, ~> 4.0, and ~> 5.0.

See the CI [build status](https://travis-ci.org/krisleech/wisper-activerecord) for more information.

## Contributing

Please submit a Pull Request with specs.

### Running the specs

```
bundle exec rspec
```
