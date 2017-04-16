class AddInvitableToMemberships < ActiveRecord::Migration
  def change
    change_table :memberships do |t|
      t.string     :invitation_token
      t.datetime   :invitation_sent_at
      t.datetime   :invitation_created_at
      t.datetime   :invitation_accepted_at
      t.integer    :invited_by
      t.integer    :invitation_limit
      t.integer    :invitations_count, default: 0
      t.boolean    :active, default: true
      t.index      :invitations_count
      t.index      :invitation_token, :unique => true # for invitable
    end
  end
end
