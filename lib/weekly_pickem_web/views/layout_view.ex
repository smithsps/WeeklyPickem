defmodule WeeklyPickemWeb.LayoutView do
  use WeeklyPickemWeb, :view

  def js_script_tag do
    if Application.get_env(:weekly_pickem, :environment) == :prod do
      ~s(<script src="/js/app.js"></script>)
    else
      ~s(<script src="http://localhost:8080/js/app.js"></script>)
    end
  end

  def css_link_tag do
    if Application.get_env(:weekly_pickem, :environment) == :prod do
      ~s(<link rel="stylesheet" type="text/css" href="/css/app.css" media="screen,projection" />)
    else
      ""
    end
  end
end
