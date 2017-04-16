namespace :db do
  desc 'drop, create, migrate'
  task bootstrap: [:drop, :create, :migrate]
end
