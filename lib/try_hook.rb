class BashTryHook < Mumukit::Templates::FileHook
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

  def result_sections
    [:extras, :cookies, :current_query, :goal]
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

  def post_process_file(file, result, status)
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
      extra: $1,
      cookies: $2,
      query: to_query_result($3),
      goal: $4,
      status: status
    }

    check_results = @checker.check(results, @goal)

    [check_results[2], check_results[1], results[:query]]
  end

  def to_query_result(query_result)
    result, _, status = query_result.rpartition("\n")
    status = status == '0' ? :passed : :failed
    {result: result, status: status}
  end

  def compile(request)
    @goal = {postconditions: [[request.goal.with_indifferent_access[:kind], request.goal]]}
    @checker = Bash::Checker.new request
    super request
  end

end
