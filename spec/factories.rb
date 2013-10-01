FactoryGirl.define do
  sequence(:random_string) {|n| Digest::MD5.hexdigest(n.to_s) }
  sequence(:random_email) {|n| "#{n}@example.com" }
  sequence(:count)
  sequence(:sequencial_number) {|n| n }
end

module FactoryGirl::Syntax::Methods
  def sn
    generate(:sequencial_number)
  end
end