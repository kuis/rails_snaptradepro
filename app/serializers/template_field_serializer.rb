class TemplateFieldSerializer < ActiveModel::Serializer
  attributes :id, :name, :label, :field_type, :weight, :has_effect_on_other_fields, :editable_by_user
end
