fx_version 'cerulean'

game 'gta5'

author 'ZOBYETEAM'
description 'Party System By ZOBYETEAM'
version '2.0.7'

lua54 'yes'

client_scripts {
    'config/config.lua',
    'config/config_callback.lua',
    'client/main.lua'
}

server_script {
    'config/config.lua',
    'config/config_callback.lua',
    'server/main.lua'
}

ui_page 'interface/index.html'

files {
    'interface/**'
}