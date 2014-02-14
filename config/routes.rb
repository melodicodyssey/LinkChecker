LinkChecker::Application.routes.draw do
  root 'sites#new'
  get '/sites/new', to: 'sites#new', as: 'new_site'
  post '/sites', to: 'sites#create', as: 'sites'
  get '/sites/:id/edit', to: 'sites#edit'
  get '/sites/:id', to: 'sites#show', as: 'site'
  delete '/sites/:id', to: 'sites#delete'
  get '/linkfarm', to: 'sites#linkfarm'
end
