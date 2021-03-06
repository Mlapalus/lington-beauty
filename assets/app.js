/*
 * Welcome to your app's main JavaScript file!
 *
 * We recommend including the built version of this JavaScript file
 * (and its CSS file) in your base layout (base.html.twig).
 */

// any CSS you import will output into a single css file (app.scss in this case)
import './styles/app.scss';
import './js/bootstrap.min';
import './js/classie';
import './js/contact';
import './js/custom';
import './js/mail-script';
import './js/uisearch';
import './js/jquery-1.12.1.min';
import './js/jquery.ajaxchimp.min';
import './js/jquery.form';
import './js/jquery.nice-select.min';
import './js/jquery.validate.min';
import './js/popper.min';
import './js/uisearch';

// start the Stimulus application
import './bootstrap';

const $ = require('jquery');
// this "modifies" the jquery module: adding behavior to it
// the bootstrap module doesn't export/return anything
require('bootstrap');

// or you can include specific pieces
// require('bootstrap/js/dist/tooltip');
// require('bootstrap/js/dist/popover');

$(document).ready(function() {
    $('[data-toggle="popover"]').popover();

});
