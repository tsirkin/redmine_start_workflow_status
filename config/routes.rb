ActionController::Routing::Routes.draw do |map|
  map.resources :issue_statuses, :except => :show, :collection =>
  {:update_issue_done_ratio => :post,:update_multiple => :post},
  :singular => :issue_status
end
