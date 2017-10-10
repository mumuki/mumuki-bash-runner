module Bash
  class Checker < Mumukit::Metatest::Checker

    def initialize(request)
      @request = request
    end

    def check_last_query_equals(_result, goal)
      expected = goal[:query]
      actual = @request.query
      fail_t :check_last_query_equals, expected: expected, actual: actual unless expected == actual
    end

    def check_last_query_matches(_result, goal)
      regex = goal[:regex]
      fail_t :check_last_query_matches, regex.to_s unless regex.matches? @request.query
    end

    def check_last_query_fails(result, _goal)
      fail_t :check_last_query_fails unless result[:query][:status] == :failed
    end

    def check_last_query_outputs(result, goal)
      expected = goal.with_indifferent_access[:output]
      actual = result[:query][:result]
      fail_t :check_last_query_outputs, expected: expected, actual: actual unless expected == actual
    end

    def check_last_query_passes(result, _goal)
      fail_t :check_last_query_passes unless result[:query][:status] == :passed
    end

    def check_query_passes(result, goal)
      fail_t :check_query_passes, query: goal.with_indifferent_access[:query] unless result[:status] == :passed
    end

    def check_query_fails(result, goal)
      fail_t :check_query_fails, query: goal.with_indifferent_access[:query] unless result[:status] == :failed
    end

    def check_query_outputs(result, goal)
      expected = goal.with_indifferent_access[:output]
      actual = result[:goal]
      fail_t :check_query_outputs, query: goal.with_indifferent_access[:query], expected: expected, actual: actual unless expected == actual
    end

    def render_success_output(_value)
      I18n.t :goal_passed
    end

    def fail_t(sym, *args)
      fail I18n.t sym, *args
    end
  end
end
