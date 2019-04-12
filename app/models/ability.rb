# frozen_string_literal: true

class Ability
  include CanCan::Ability

  # CanCanCan assumes that you have a method called 'current_user' available in your ApplicationController (which we do). CanCanCan gets automatically initialized with 'current_user' passed to the 'initialize' method.
  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
      user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # Here we're defining a rule about who is able to `edit` a particular question in this case, we're saying if the signed in user id is the same as question id then allow `editing` the question.
    # IMPORTANT: defining a rule here doesn't enforce it, you will have to enforce this rule yourself in the view and controller where applicable.

    if user.is_admin?
      can :manage, :all # manage means they can do everything (not just CRUD)
    end

    # can :edit, Question, user_id: user.id
    alias_action :create, :read, :update, :destroy, to: :crud
    can :crud, Question, user_id: user.id

    can :crud, Answer do |ans|
      ans.user == user || ans.question.user == user

    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
end
