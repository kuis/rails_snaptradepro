class AddDetailInfoToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :trade_name,           :string
    add_column :organizations, :street_address,       :string
    add_column :organizations, :city,                 :string
    add_column :organizations, :state,                :string
    add_column :organizations, :zipcode,              :string
    add_column :organizations, :call_to_action,       :string
    add_column :organizations, :sale_sheet_phone,     :string
    add_column :organizations, :toll_free,            :string
    add_column :organizations, :main,                 :string
    add_column :organizations, :sales,                :string
    add_column :organizations, :service,              :string
    add_column :organizations, :parts,                :string
    add_column :organizations, :commentary,           :text
    add_column :organizations, :location,             :string
    add_column :organizations, :sale_term_conditions, :text
    add_attachment :organizations,                    :company_logo
    add_attachment :organizations,                    :map_image
  end
end
