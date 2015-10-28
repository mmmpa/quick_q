//= require jquery-2.1.4.min
//= require jquery_ujs
//= require bootstrap.min
//= require sweetalert.min

function notifySuccess(title, message) {
    riseNotification('success', title, message)
}

function notifyDanger(title, message) {
    riseNotification('danger', title, message)
}

function notifyInfo(title, message) {
    riseNotification('info', title, message)
}

function notifyWarning(message) {
    riseNotification('warning', title, message)
}

function riseNotification(type, title, message) {
    $('html').append($('<div class="alert alert-%%type%% notification-box"><button type="button" class="close" data-dismiss="alert">x</button> <strong>%%title%%</strong> %%message%%</div>'.replace('%%title%%', title).replace('%%message%%', message).replace('%%type%%', type)));
    $(".notification-box").delay(200).fadeTo(500, 1).delay(2000).fadeTo(500, 0, function () {
        $(".notification-box").alert('close');
    });
}

$(function () {
    var $longTextWrappers = $('.long-text-wrapper');
    var adjust = function(){
        $longTextWrappers.css({width: '100%', 'white-space': 'normal'});
        $longTextWrappers.each(function(_, el){
            var $wrapper = $(el);
            $wrapper.css({width: $wrapper.width() - 50, 'white-space': 'nowrap'});
        });
    }
    $(window).resize(adjust);
    adjust();
});
