defmodule Panda.Router do
  use Plug.Router
  use Plug.ErrorHandler

  plug(:match)
  plug(:dispatch)

  get "/matches/:id/winning_probabilities" do
    content = Panda.winning_probabilities_for_match(id)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(content))
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end

  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    IO.inspect(kind, label: :kind)
    IO.inspect(reason, label: :reason)
    IO.inspect(stack, label: :stack)
    send_resp(conn, conn.status, "Something went wrong")
  end
end
