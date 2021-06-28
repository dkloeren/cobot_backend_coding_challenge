Rails.application.routes.draw do
  root to: redirect('/import/new')

  resource :import
end
