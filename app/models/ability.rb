class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud

    if user
      can :create, Form
      can :read, Form, user_id: user.id
      can :update, Form, user_id: user.id
      can :destroy, Form, user_id: user.id
      can :trash, Form, user_id: user.id

      can :read, Submission do |submission|
        submission.form_id.in? user.form_ids
      end

      can :delete, Submission do |submission|
        submission.form_id.in? user.form_ids
      end

      can :undelete, Submission do |submission|
        submission.form_id.in? user.form_ids
      end
    end
  end
end
