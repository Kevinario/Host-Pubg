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
    #Reactive server if active is false. Or Something like that here
    status 200
  end
  
  #Failed and refunded invoices
  events.subscribe 'invoice.payment_failed' do |event|
    orderID = event.data.object.lines.data[0].metadata.order_id
    unless purchase = Purchase.find(orderID.to_i)
      status 400
      return
    end
    
    
    #MAYBE MOVE THIS TO SUBSCRIPTION DELETED
    if purchase.expireDate <= Time.now.to_date
      #Cancel Server
      purchase.update(active: false)
      #Run command to shut down server
    end
    
    status 200
  end
  
  events.subscribe 'customer.subscription.deleted' do |event|
    orderID = event.data.object.metadata.order_id
    unless purchase = Purchase.find(orderID.to_i)
      status 400
      return
    end
    
    unless server = Server.find_by(purchase_id: orderID.to_i)
      status 400
      return
    end
    
    purchase.update(active: false, expired: true)
    #Do stuff to shut down server
    server.update(status: "Expired")
    
    
    
    
  end
    
  
  
  
  
  
  #ADD REFUND LATER
end


StripeEvent.signing_secret = "whsec_DnIzzRJSo6BntNaSvJT3pbPUIWnEmDVP"

