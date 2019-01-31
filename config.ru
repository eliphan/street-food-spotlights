require './config/environment'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use Rack::MethodOverride #this will let the app know how to handle PATCH, PUT, DELETE requests
run ApplicationController
use PostsController
use UsersController
