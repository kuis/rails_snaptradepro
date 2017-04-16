class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :account_name, :first_name, :last_name,
    :email, :business_phone, :direct_phone, :street_address,
    :city, :state_or_provence, :postal_code, :mobile_phone
end
