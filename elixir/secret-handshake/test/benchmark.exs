tests = %{
  "commands" => fn -> SecretHandshake.commands(15) end,
  "commands_list" => fn -> SecretHandshake.commands_list(15) end
}

Benchee.run(tests)
