require_relative '../test_helper' 

class SubscriptionTest < ActiveSupport::TestCase
  setup { @subs = Subscription.new }

  test '#failed? (without arguments)' do
    assert !@subs.failed?
    assert !@subs.merge('99' => '200').failed?
    assert  @subs.merge('99' => '500').failed?
  end

  test '#failed? (with arguments)' do
    @subs.merge!('99' => '200', '88' => '500')
    assert !@subs.failed?('99')
    assert @subs.failed?('88')
  end
end
