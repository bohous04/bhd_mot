fx_version 'cerulean'
lua54 'yes'
game 'gta5'
name 'bhd_mot'
version '1.0.0'
author 'BHD SCRIPTS'
docs 'https://docs.bhdscripts.com/scripts/bhd-mot'
discord 'https://discord.gg/xZZu23AcpP'
description 'Advanced mechanic operations for FiveM'

files {
    "locales/*.json"
}

shared_scripts {
    '@ox_lib/init.lua',
    "config.lua"
}

client_scripts {
    "client/*.lua",
}
server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/*.lua",
}

escrow_ignore {
    'config.lua',
    'config_s.lua',
    'locales/*.json',
    'client/editable.lua',
    'server/editable.lua'
}