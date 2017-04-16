class AppraisalCategorySerializer < ActiveModel::Serializer
  def initialize(object, options={})
    super
    @appraisal = options[:appraisal]
    @completed_only = options.fetch(:completed_only) { false }
    @include_fields = options.fetch(:include_fields) { false }
  end

  attributes :id, :label, :weight, :fields

  def fields
    fields = object.template_fields

    fields = fields.map do |field|
      field_details = {
          label: field.display_attribute(@appraisal.organization),
          print_label: field.display_attribute(@appraisal.organization,:print_label),
          field_type: field.field_type,
          value: @appraisal.field_value(field.id),
          required: field.required?,
          weight: field.weight,
          has_effect_on_other_fields: field.has_effect_on_other_fields,
          editable_by_user: field.editable_by_user,
          viewable: field.showable?(:view,@appraisal.organization,@current_user),
          editable: field.showable?(:edit,@appraisal.organization,@current_user)
      }

      field_details[:choices] = field.choices_array if field.choices_required?
      field_details[:formatting] = field.formatting if field.has_formatting?

      if @appraisal.field_value(field.id).blank? && @completed_only
        nil
      else
        [field.id, field_details]
      end
    end

    Hash[fields.compact]
  end

  attr_accessor :include_fields
  alias :include_fields? :include_fields
end
