import Rails from '@rails/ujs'
import Turbolinks from 'turbolinks'
import 'channels'

Rails.start()
Turbolinks.start()
require('jquery')
import 'bootstrap'

require('packs/argon')
require('packs/bootstrap.bundle.min')
require('packs/jquery-scrollLock.min')
require('packs/jquery.min')
require('packs/jquery.scrollbar.min')
