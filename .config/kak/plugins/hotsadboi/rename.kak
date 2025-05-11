hook global ClientCreate .* %{
    eval %sh{
        bash /home/hotsadboi/.config/kak/plugins/hotsadboi/names.sh client $kak_client
    }
}

def -hidden -override random-name %{
    eval %sh{
        bash /home/hotsadboi/.config/kak/plugins/hotsadboi/names.sh session $kak_session
    }
}
