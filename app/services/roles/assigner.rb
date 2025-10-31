module Roles
  class Assigner
    def initialize(user)
      @user = user
    end

    def call
      if premium_purchase_confirmed?
        assign_premium_role
      else
        assign_user_role
      end
    end

    def assign_premium_role_command(amount_of_days)
      assign_premium_role(amount_of_days)
    end

    private

    def premium_purchase_confirmed?
      # Placeholder logic for checking premium purchase
      # In a real application, this would check the user's purchase status
      # @user.premium_purchase_confirmed?
    end

    def assign_premium_role(amount_of_days = 30)
      @user.update_columns(
        roles: "premium",
        premium_start: Time.current,
        premium_until: amount_of_days.days.from_now
      )
    end

    def assign_user_role
      @user.update_columns(
        roles: "user",
        premium_start: nil,
        premium_until: nil
      )
    end
  end
end
