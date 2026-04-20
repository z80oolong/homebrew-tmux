module DiffDataMixin
  def diff_data
    path.readlines(nil).first.gsub(/^.*\n__END__\n/m, "")
  end
end

module EnvExtend
  def append_rpath(*append_list)
    append_list = (append_list.map {|path| path.to_s }).join(":")

    if (rpaths = fetch("HOMEBREW_RPATH_PATHS", false))
      self["HOMEBREW_RPATH_PATHS"] = "#{append_list}:#{rpaths}"
    end
  end

  def replace_rpath(**replace_list)
    replace_list = replace_list.each_with_object({}) do |(old, new), result|
      result[old.to_s] = new.to_s
    end

    if (rpaths = fetch("HOMEBREW_RPATH_PATHS", false))
      self["HOMEBREW_RPATH_PATHS"] = (rpaths.split(":").map do |rpath|
        replace_list.fetch(rpath, rpath)
      end).join(":")
    end
  end
end
