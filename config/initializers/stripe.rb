Rails.configuration.stripe = {
  :publishable_key => 'pk_test_9yrB5cuD9OgMUTv1tUG6YaGT', #ENV['PUBLISHABLE_KEY'],
  :secret_key      => 'sk_test_8jlCzyLYkTngoPWqg6Wmxwg3' #ENV['SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
#Stripe.signing_secret = "whsec_DnIzzRJSo6BntNaSvJT3pbPUIWnEmDVP"

StripeEvent.configure do |events|
  events.subscribe 'customer.subscription.created' do |event|
    orderID = event.data.object.metadata.order_id
    unless purchase = Purchase.find(orderID.to_i)
      status 400
      return
    end
    unless Server.find_by(purchase_id: purchase.id)
      Server.create(name: "Default", status: "Preparing", purchase_id: purchase.id)
    end
    #Could move status 200 into the unless bracket, then trigger an error associated with webhooks misfiring
    status 200
  end
  
  events.subscribe 'invoice.payment_succeeded' do |event|
    orderID = event.data.object.lines.data[0].metadata.order_id
    unless purchase = Purchase.find(orderID.to_i)
      status 400
      return
    end
    purchase.update(active: true, expireDate: Time.now.to_date + 1.month)
    status 200
  
  end
end


StripeEvent.signing_secret = "whsec_DnIzzRJSo6BntNaSvJT3pbPUIWnEmDVP"

