ESpec.configure fn(config) ->
  config.formatters [
    {ESpec.Formatters.Doc, %{diff_enabled?: false}}
  ]
  
  config.before fn(tags) ->
    {:shared, tags: tags}
  end

  config.finally fn(_shared) ->
    :ok
  end
end
