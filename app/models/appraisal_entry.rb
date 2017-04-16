class AppraisalEntry < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  acts_as_paranoid

  has_paper_trail on: [:update, :destroy]

  belongs_to :appraisal
  belongs_to :template_field

  validates :template_field, presence: true

  serialize :value

  after_save :adjust_last6_and_last7

  def field_label
    self.template_field.label
  end

  def value=(input)
    input.reject! { |v| v.blank? } if input.is_a?(Array)
    self[:value] = input
  end

  def readable_value
    if numeric?
      formatted_number
    elsif value.is_a?(Array)
      value.join(", ")
    elsif text?
      formatted_text
    else
      value
    end
  end

  def set_value(value)
    if numeric?
      self.numeric = value
    else
      self.value = value
    end
  end

  def get_value
    numeric? ? numeric : value
  end

  private

  def numeric?
    template_field && template_field.field_type == "Numeric"
  end

  def text?
    template_field.field_type == "Text Field" || template_field.field_type == "Text Area"
  end

  def formatted_number
    formatting = template_field.parsed_formatting

    options = {delimiter: ("," if formatting["comma-separated"])}

    if formatting["digits-after-decimal"]
      options[:precision] = formatting["digits-after-decimal"]
    else
      options[:precision] = 0
    end

    number = number_with_precision numeric, options
    number = "#{formatting['currency-symbol']} #{number}" if formatting["currency-symbol"]
    number
  end

  def formatted_text
    return unless value.present?
    formatting = template_field.parsed_formatting

    return value unless formatting.present?

    text = value.downcase
    letters = text.split(' ')

    case formatting["capitalization"]
    when 'first-letter'
      letters[0].capitalize!
    when 'first-letter-all-words'
      letters.map(&:capitalize!)
    when 'all-words'
      letters.map(&:upcase!)
    end

    letters.join(' ')
  end

  def adjust_last6_and_last7
      if self.template_field.name == 'serial_no' && self.template_field.has_effect_on_other_fields?
        last6_template_field = TemplateField.find_by_name('last6')
        last8_template_field = TemplateField.find_by_name('last8')
        if last6_template_field && last8_template_field
          last6_appraisal_entry = AppraisalEntry.find_or_create_by(
              appraisal_id: self.appraisal.id,
              template_field_id: last6_template_field.id
          )
          last8_appraisal_entry = AppraisalEntry.find_or_create_by(
              appraisal_id: self.appraisal.id,
              template_field_id: last8_template_field.id
          )
          if self.value.to_s.length < 6
            last6_appraisal_entry.update_attribute(:value, nil)
            last8_appraisal_entry.update_attribute(:value, nil)
          elsif self.value.to_s.length < 8
            last6_appraisal_entry.update_attribute(:value, self.value[-6..-1])
            last8_appraisal_entry.update_attribute(:value, nil)
          else
            last6_appraisal_entry.update_attribute(:value, self.value[-6..-1])
            last8_appraisal_entry.update_attribute(:value, self.value[-8..-1])
          end
        end
      end
  end
end
