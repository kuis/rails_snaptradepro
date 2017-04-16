module MemberHelper
  def is_manager?(user=current_user)
    @organization.admin?(user) || @organization.owner?(user) || user.admin?
  end

  def is_manager_or_member?
    is_manager? || @organization.member?(current_user)
  end

  def can_edit?(member)
    current_user == member || (is_manager? && !is_manager?(member))
  end

  def membership_role_tag(membership)
    fields_for @organization do |org|
      org.fields_for :users do |m|
        if m.object == membership.user
          m.fields_for :memberships, membership do |ms|
            select = ms.select :role_id, options_from_collection_for_select(Role.reps, :id, :profile, membership.role_id), {}, class: 'form-control input-sm'
          end
        end
      end
    end
  end

  def membership_active_tag(membership)
    fields_for @organization do |org|
      org.fields_for :users do |m|
        if m.object == membership.user
          m.fields_for :memberships, membership do |ms|
            ms.check_box :active, {value: membership.active?}, 't', 'f'
          end
        end
      end
    end
  end

  def membership_invitation_status(membership)
    if membership.invitation_accepted_at.present?
      content_tag :span, 'Accepted', class: 'label label-success'
    elsif membership.invitation_sent_at.present?
      content_tag :span, 'Sent', class: 'label label-primary'
    elsif membership.invitation_token.present?
      content_tag :span, 'Pending', class: 'label label-warning'
    elsif membership.invitation_created_at.present? && membership.invitation_token.nil?
      content_tag :span, 'Revoked', class: 'label label-danger'
    end
  end
end
