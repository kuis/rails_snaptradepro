ActiveAdmin.register EquipmentType do
  actions :all, except: :destroy

  filter :name
  filter :label



  form do |f|
    f.inputs do
      f.input :name
      f.input :label
      f.inputs do
        f.template.render partial: 'can_be_converted_to_et', locals: { f: f }
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :label
      row "Can Be Converted To" do |et|
        et.can_be_converted_to_ets.map(&:name_with_label)
      end
    end
  end

  index do
    id_column
    column :name
    column :label
    column "Can Be Converted To" do |et|
      et.can_be_converted_to_ets.map(&:name_with_label)
    end
    actions
  end

end
