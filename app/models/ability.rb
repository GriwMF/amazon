class Ability
  include CanCan::Ability

  def initialize(customer)
    # Define abilities for the passed in user here. For example:
    #
    if customer
      if customer.admin?
        can :manage, :all
        can :access, :rails_admin   # grant access to rails_admin
        can :dashboard
      else
        can :read, :all
        can :manage, [Address, CreditCard, Customer]
        can [:rate, :add_wished, :wished, :home], Book
        can [:update, :add_item, :remove_item, :recent, :cart, :destroy,
            :check_out, :addresses, :delivery, :credit_card, :complete], Order
      end
    else
        can :read, :all
        can :home, Book
        can [:add_item, :remove_item, :cart, :update], Order
      #customer = Customer.new # guest user (not logged in)
    end
      
    #
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
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
