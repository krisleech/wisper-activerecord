ActiveRecord::Schema.define do
  self.verbose = false

  create_table :meetings, :force => true do |t|
    t.string  :title, default: 'My Meeting'
    t.string  :location
    t.timestamps
  end
end
