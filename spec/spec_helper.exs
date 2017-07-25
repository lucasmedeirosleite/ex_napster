ESpec.configure fn(config) ->
  config.formatters [
    {ESpec.Formatters.Doc, %{diff_enabled?: false}}
  ]

  config.before fn(tags) ->
    ExVCR.Config.cassette_library_dir("spec/cassettes")
    {:shared, tags: tags}
  end

  config.finally fn(_shared) ->
    :ok
  end
end
