defmodule WeeklyPickem.Web.PageView do
  use WeeklyPickem.Web, :view

  def js_script_tag do
    if Application.get_env(:weekly_pickem, :environment) == :prod do
      ~s(<script src="/js/app.js"></script>)
    else
      ~s(<script src="http://localhost:8080/js/app.js"></script>)
    end
  end
end
