# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :appraisal do
    sequence(:name) { |n| "Appraisal Named #{n}" }
    organization
    status "Assessment"
    unit "A Unit"
    user

    after(:build) do |appraisal|
      unless appraisal.customer
        appraisal.customer = create(:customer, organization: appraisal.organization)
      end

      unless appraisal.appraisal_template
        template = create(:appraisal_template)
        appraisal.organization.appraisal_templates << template
        appraisal.appraisal_template = template
      end

      appraisal.number = appraisal.organization.next_appraisal_number(increment: true)
    end
  end
end
