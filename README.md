# Wisper::ActiveRecord [WIP]

Transparently publish all model changes to subscribers.

## Installation

```ruby
gem 'wisper-activerecord'
```

## Usage

**Add the plugin to every `ActiveRecord` model (optional)**

```ruby
Wisper::ActiveRecord.include
```

**Our model**

```ruby
class Meeting < ActiveRecord::Base
end
```

**Lets subscribe a listener**

```ruby
Wisper::ActiveRecord.subscribe(Auditor.new)
```

**Which simply logs all events in memory**

```ruby
class Auditor
  include Singleton

  attr_accessor :audt

  def initialize
    @audit = []
  end

  def on_create(subject)
    audit.push(audit_for(‘create’, subject))
  end

  def on_update(subject)
    audit.push(audit_for(‘update’, subject))
  end

  def on_destroy(subject)
    audit.push(audit_for(‘destroy’, subject))
  end

  def self.audit
    instance.audit
  end

  private

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
Auditor.audit # => […]
```

Supports:

* create, update, destroy
* update_attribute
* regular setter

## Contributing

Please submit a Pull Request with specs.
