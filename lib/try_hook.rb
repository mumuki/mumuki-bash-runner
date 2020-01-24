class BashTryHook < Mumukit::Templates::TryHook
  isolated true

  def tempfile_extension
    '.sh'
  end

  def compile_file_content(r)
    @custom_allowed_commands = r.settings.try { |settings| settings['allowed_commands'] }
    <<~bash
      (echo #{extra_separator}
      #{r.extra}
      echo #{cookie_separator}
      #{(r.cookie || []).join("\n")}
      echo #{query_separator}
      #{r.query}
      echo $?
      echo #{goal_separator}
      #{r.goal.with_indifferent_access[:query]}) 2>&1
    bash
  end

  def command_line(filename)
    ['runbash', allowed_commands, filename]
  end

  def extra_separator
     '!!!MUMUKI-EXTRA-START!!!'
  end

  def cookie_separator
    '!!!MUMUKI-COOKIE-START!!!'
  end

  def query_separator
    '!!!MUMUKI-QUERY-START!!!'
  end

  def goal_separator
    '!!!MUMUKI-GOAL-START!!!'
  end

  def to_structured_results(_file, result, status)
    /#{extra_separator}
?(.*)
#{cookie_separator}
?(.*)
#{query_separator}
?(.*)
#{goal_separator}
?(.*)
/m =~ result
    {
      query: to_query_result($3),
      goal: $4,
      status: status
    }
  end

  def to_query_result(query_output)
    return {result: "<nothing>", status: :failed} if query_output.nil?

    result, _, status = query_output.rpartition("\n")
    status = status == '0' ? :passed : :failed
    {result: result, status: status}
  end

  def create_tempfile
    file = super
    %x{chmod o+r #{file.path}}
    file
  end

  def required_commands
    %w(bash sh)
  end

  def default_allowed_commands
    %w(whoami cat cp grep ln ls mkdir mv rm rmdir sed touch git head tail wc)
  end

  def allowed_commands
    [@custom_allowed_commands.presence || default_allowed_commands, required_commands].join ' '
  end
end
