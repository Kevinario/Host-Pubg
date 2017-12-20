Rails.configuration.stripe = {
  :publishable_key => 'pk_test_9yrB5cuD9OgMUTv1tUG6YaGT', #ENV['PUBLISHABLE_KEY'],
  :secret_key      => 'sk_test_8jlCzyLYkTngoPWqg6Wmxwg3' #ENV['SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]