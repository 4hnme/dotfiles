hook global ClientCreate .* %{
    evaluate-commands %sh{
        bash /home/hotsadboi/.config/kak/plugins/hotsadboi/names.sh client $kak_clients
    }
}

define-command -hidden -override random-name %{
    evaluate-commands %sh{
        bash /home/hotsadboi/.config/kak/plugins/hotsadboi/names.sh session $kak_session
    }
}
