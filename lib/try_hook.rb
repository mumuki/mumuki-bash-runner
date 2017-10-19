class BashTryHook < Mumukit::Templates::TryHook
  isolated true

  def tempfile_extension
    '.sh'
  end

  def compile_file_content(r)
    <<bash
echo #{extra_separator}
#{r.extra}
echo #{cookie_separator}
#{(r.cookie || []).join("\n")}
echo #{query_separator}
#{r.query}
echo $?
echo #{goal_separator}
#{r.goal.with_indifferent_access[:query]}
bash
  end

  def command_line(filename)
    "bash #{filename}"
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

  def post_process_file(_file, result, status)
    /#{extra_separator}
?(.*)
#{cookie_separator}
?(.*)
#{query_separator}
?(.*)
#{goal_separator}
?(.*)
/m =~ result

    results = {
      query: to_query_result($3),
      goal: $4,
      status: status
    }

    check_results = check(results)

    [check_results[2], check_results[1], results[:query]]
  end

  def to_query_result(query_output)
    result, _, status = query_output.rpartition("\n")
    status = status == '0' ? :passed : :failed
    {result: result, status: status}
  end

  def create_tempfile
    file = super
    %x{chmod o+r #{file.path}}
    file
  end

end
