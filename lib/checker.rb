module Bash
  class Checker < Mumukit::Metatest::Checker
    def check_last_query_equals(result, expected)
      fail 'check_last_query_equals' unless @request[:query] == expected
    end

    def check_last_query_matches(result, regex)
      fail 'check_last_query_matches' unless regex.matches? @request[:query]
    end

    def check_last_query_fails(result, _expected)
      fail 'check_last_query_fails' unless result[:query][:status] == :failed
    end

    def check_last_query_passes(result, _expected)
      fail 'check_last_query_passes' unless result[:query][:status] == :passed
    end

    def check_query_passes(result, _expected)
      fail 'check_query_passes' unless result[:status] == :passed
    end

    def check_query_fails(result, _expected)
      fail 'check_query_fails' unless result[:status] == :failed
    end

    def check_query_outputs(result, expected)
      fail 'check_query_outputs' unless result[:goal] == expected[:output]
    end

    def render_success_output(value)
      'all good'
    end
  end
end
