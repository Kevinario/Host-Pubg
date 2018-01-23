class HooksController < ApplicationController
    require 'json'
    
    def charge
        Post.create(caption: "Thingo", title: "Thingo")
        endpoint_secret = "whsec_DnIzzRJSo6BntNaSvJT3pbPUIWnEmDVP"
        sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
        
        event = nil
        payload = request.body.read
        
        begin
            event = Stripe::Webhook.construct_event(
                payload, sig_header, endpoint_secret
            )
        rescue JSON::ParserError => e
            status 400
            return
        rescue Stripe::SignatureVerificationError => e
            status 400
            return
        end
            
        
        if event.type == "customer.subscription.created"
            orderID = event.data.object.metadata.orderID
            customer = Stripe::Customer.retieve(event.data.object.customer)
            
            user = find_by(email: customer.email)
            purchases = Purchase.find_by(user_id: user.id)
            
            
            purchases.select do |p|
                if p.id == orderID
                    purchaseID = p.id
                    break
                end
            end
            
            #If purchaseID is nil. Error. Add Handling Later
            if purchaseID.nil?
                status 400
                return
            end
            
            Server.create(name: "Default",status: "Preparing",purchase_id: purchaseID)
            
            
            
        elsif false#event.type == "charge.succeeded"
            customer = Stripe::Customer.retrieve(event.data.object.customer)
            user = User.find_by(email: customer.email)
            purchases = Purchase.find_by(user_id: user.id)
            
            
            orderID = event.data.object.invoice.subscription.metadata.order_id
            purchases.select do |p|
                if p.id == orderID
                    purchaseID = p.id
                    break
                end
            end
            #If @purchaseID has not been set by this point, error will occur. Add error handling later.
            if purchaseID.nil?
                status 400
                return
            end
            server = !Server.find_by(purchase_id: purchaseID)
            
            if !server
                #Maybe create defaults in schema. Would be easier.
                Server.create(name: "Default", status: "Preparing")
            else
                purchase = Purchase.find_by(id: purchaseID)
                purchase.update(active: true, expireDate: Time.now + 1.month)
            end
        elsif event.type == "charge.failed"
        
        elsif event.type == "charge.refunded"
            
        end
        
        status 200
    end
end
