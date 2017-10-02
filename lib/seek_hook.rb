class BashSeekHook < Mumukit::Templates::FileHook
  isolated true

  def tempfile_extension
    '.sh'
  end

  def compile_file_content(r)
    <<bash
#{r.extra}
    #{(r.cookie || []).join("\n")}
echo $(#{r.query})
bash
  end

  def command_line(filename)
    "runbash #{filename}"
  end
end
