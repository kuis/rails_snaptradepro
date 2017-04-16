Rails.application.routes.draw do
  resources :checklists do
    resources :checklist_items do
      member do
        post :completed
        post :uncompleted
      end
    end
  end
  resources :valuation_url_comments

  get 'members/index'

  ActiveAdmin.routes(self)

  devise_for :users, controllers: { sessions: 'sessions' }

  root to: "pages#home"

  resources :pre_launch_registrations, only: [:new, :create] do
    get :success, on: :collection
  end

  resources :organizations, only: [:show, :edit, :update] do
    resources :customers, except: :destroy do
      get :archived, on: :collection
      put :archive, on: :member
      put :bulk_archive, on: :collection
    end

    resources :appraisals, except: :destroy do
      get :archived, on: :collection
      put :archive, on: :member
      put :clone, on: :member
      get :sales_sheet, on: :member
      get :appraisal_sheet, on: :member
      put :bulk_archive, on: :collection
      get :remove_entry, on: :member
      get :history, on: :member
      post :comment, on: :member
      get :valuations, on: :member
      post :pin, on: :member
      post :unpin, on: :member
      get :reveal_comments, on: :member
      get :hide_comments, on: :member
      put :valuation, on: :member
      get :valuation_history, on: :member
      put :convert_et, on: :member
      get :find_et_templates, on: :member

      resources :discussions do
        resources :discussion_comments
      end

      resources :valuation_urls
    end

    resources :members, only: [:index, :show, :update] do
      post :invite_user, on: :collection
      get :reset_password, on: :member
      get :resend_invitation, on: :member
    end
  end

  resources :members, only: [] do
    get :accept_invitation, on: :collection
  end

  resources :attachments

  resources :reports do
    get :inventory_commitments, on: :collection
  end

  resources :print_templates

  resources :appraisal_categories, only: [:show]

  put :update_ato_visibility ,to: "appraisal_templates_organizations#update_ato_visibility"
  put :update_oet_user_creatable ,to: "organization_equipment_types#update_oet_user_creatable"

  namespace :api do
    api version: 1, module: 'v1' do
      resources :sessions, only: [:create]

      resources :appraisals, only: [:index] do
        resources :appraisal_categories, only: [:show]
      end

      resources :organizations, only: [:index] do
        resources :appraisals, only: [:create, :show, :update]
        resources :customers, only: [:create, :show, :update]
        resources :equipment_types, only: [:index,:show] do
          get :appraisals, on: :member
          get :archived_appraisals, on: :member
        end
      end
    end
  end
end
