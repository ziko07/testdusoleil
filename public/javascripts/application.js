// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


$(document).ready(function() {

  $("span[rel=popover],a[rel=popover],a[data-rel=popover]").popover({
    offset: 10,
    placement: "right"
  }).addClass('pointer');

  $("span[rel=tooltip],a[rel=tooltip],a[data-rel=tooltip]").tooltip({
    live: true
  }).addClass('pointer');
  
});

$(function () {
    var tz = $.set_timezone();
    $.cookie('timezone', tz, {path: '/'});
});
