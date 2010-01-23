#
# A Blue Jazz Consulting utility that provides for a simple, declarative method of including Javascript "controllers"
# that manage the user interface. It mimics the Rails controller/helper pattern for client-side scripting support.
#
# From within an ERb page:
#
#  require_js_controllers :foo, :bar # adds js includes for foo_controller.js, bar_controller.js
#  require_js_helpers :foo, :bar # adds js includes for foo_helper.js, bar_helper.js
#
#
module JavascriptControllerSystem

  def require_js_controllers(*args)
    controllers = args.is_a?(Array) ? args : [args]
    @js_controllers = controllers
  end

  def require_js_helpers(*args)
    helpers = args.is_a?(Array) ? args : [args]
    @js_helpers = helpers
  end

  def add_js_requires
    @js_controllers ||= []
    @js_helpers ||= []
    return @js_controllers.collect { |controller| javascript_include_tag("#{controller}_controller") }.join("") +
           @js_helpers.collect     { |helper| javascript_include_tag("#{helper}_helper") }.join("")
  end
end
