# IngredientsPlug

## Installation
Add in `mix.exs`
```elixir
def deps do
  [
    {:ingredients_plug, github: "TV4/ingredients_plug"}
  ]
end
```

In `endpoint.ex` add the following plug:
```elixir
  plug IngredientsPlug,
    framework: %{name: "phoenix", version: elem(Mix.Dep.Lock.read().phoenix, 2)}
```
