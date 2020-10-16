#!/bin/bash

bundle exec rspec spec/models/user_spec.rb 
bundle exec rspec spec/models/target_spec.rb
bundle exec rspec spec/models/habit_spec.rb
bundle exec rspec spec/models/small_target_spec.rb
bundle exec rspec spec/system/users_spec.rb
bundle exec rspec spec/system/targets_spec.rb 
bundle exec rspec spec/system/habits_spec.rb
bundle exec rspec spec/system/small_targets_spec.rb

exit 0
