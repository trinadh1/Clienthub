class BillingController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:webhook]
  before_action :authenticate_user!, except: [:webhook]


  def checkout
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      customer_email: current_user.email,
      line_items: [{
        price: ENV['STRIPE_PRICE_ID'], # Monthly plan price ID from Stripe
        quantity: 1
      }],
      mode: 'subscription',
      success_url: billing_url + "?checkout=success",
      cancel_url: billing_url + "?checkout=cancel"
    )

    redirect_to session.url, allow_other_host: true, status: 303
end 
  def webhook
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil
       begin
      event = Stripe::Webhook.construct_event(
        payload,
        sig_header,
        ENV['STRIPE_WEBHOOK_SECRET']
      )
    rescue JSON::ParserError => e
      render json: { error: 'Invalid payload' }, status: 400 and return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: 'Invalid signature' }, status: 400 and return
    end
     case event.type
    when 'checkout.session.completed'
      session = event.data.object
      user = User.find_by(email: session.customer_email)

      user.create_subscription!(
        stripe_customer_id: session.customer,
        stripe_subscription_id: session.subscription,
        status: 'active',
        plan: 'pro'
      )
    end

    head :ok
  end
end
