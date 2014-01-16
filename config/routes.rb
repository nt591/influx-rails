InfluxRails::Application.routes.draw do

  get 'sql', to: 'events#sql', as: :sql
  get 'mysql', to: 'events#query_mysql', as: :query_mysql
  get 'influx', to: 'events#query_influx', as: :query_influx
  
  root 'events#home'
end
