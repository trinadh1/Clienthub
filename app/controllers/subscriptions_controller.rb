class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def show
    @subscription = current_user.subscription
  end

  def create_checkout_session
    price_id = params[:price_id]
    unless price_id.present?
      redirect_to subscription_path, alert: "Please select a plan." and return
    end

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      mode: 'subscription',
      line_items: [{
        price: price_id,
        quantity: 1
      }],
      success_url: subscription_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: subscription_url,
      customer_email: current_user.email,
      metadata: {
        user_id: current_user.id
      }
    )
    redirect_to session.url, allow_other_host: true
  rescue Stripe::StripeError => e
    redirect_to subscription_path, alert: e.message
  end

  def cancel
    subscription = current_user.subscription
    if subscription&.stripe_subscription_id.present?
      Stripe::Subscription.update(
        subscription.stripe_subscription_id,
        { cancel_at_period_end: true }
      )
      subscription.update(status: 'canceling')
      flash[:notice] = "Your subscription will cancel at the end of the billing period."
    else
      flash[:alert] = "No active subscription found."
    end
    redirect_to subscription_path
  rescue Stripe::StripeError => e
    flash[:alert] = e.message
    redirect_to subscription_path
  end
end