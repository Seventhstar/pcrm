// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/autocomplete
//= require jquery-ui/accordion
//= require jquery-ui/datepicker
//= require jquery-ui/tabs
//= require jquery.fileupload
//= require jquery.tokeninput
//= require chosen.jquery
//= require jquery.timepicker
//= require jquery.inputmask.bundle
//= require plyr
//= require jquery.mustache
//= require tinymce-jquery
//= require nprogress
//= require bootstrap-tokenfield
//= require moment
//= require cocoon
//= require contextMenu.min
//= require vue
//= require_tree .

function toInt(d){
  if (isNaN(d)) return 0;
  if (v_nil(d)) return 0;
  return parseInt(d);
}

function to_sum(d){ 
  if (isNaN(d)) return 0;
  s = d.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1 ");
  return s;
}

$.fn.capitalize = function () {
    $.each(this, function () {
        var caps = this.value;
        caps = caps.charAt(0).toUpperCase() + caps.slice(1);
        this.value = caps;
    });
    return this;
};

function updateOptionRow(name, json, id){
  let where = app[name];
  let first = true
  if (app != undefined && app.grouped != undefined){
    where = app.grouped;
    first = false;
  }

  found = searchByKey(where, id, first)

  if (first) {
    replace = where[found.gt][1]
  } else {
    replace = where[found.gt]
  }

  if (typeof(found) === "string") {
    show_ajax_message("Ошибка обновления строки заказа", "error")
  } else {
    for (var field in json) {
      replace[found.goods][field] = json[field] 
    }
  }
}

function searchByKey(obj, key, first = true) {
  for (var gt in obj) {
    let gt_obj = obj[gt]
    if (first) gt_obj = gt_obj[1]
    for (var goods in gt_obj) {
      if (gt_obj[goods].id === key) {
        return {gt: gt, goods: goods}; 
      }
    }
  }
  return "Not found";
}

function intFromSum(sum){
  if (sum === undefined) return 0;
  var s = sum.replace(/ /g, '')
  var i = parseInt(s)
  if (isNaN(i)) return 0;
  return i;
}

function showNotifications(){ 
  $nt = $(".alert"); 
  setTimeout("$nt.addClass('in')", 800);
  setTimeout("$nt.removeClass('in').addClass('out')", 7000);
}

function checkTime(i){
  if (i<10){i="0" + i;}
  return i;
}

function startTime(){
  var tm=new Date();
  var h=tm.getHours();
  var m=tm.getMinutes();
  var s=tm.getSeconds();
  
  m=checkTime(m);
  s=checkTime(s);
  $(".time_h").html(h+":"+m+":"+s);
  t=setTimeout('startTime()',500);
}

var delay = (function(){
  var timer = 0;
  return function(callback, ms){
    clearTimeout (timer);
    timer = setTimeout(callback, ms);
  };
})();

var message_template = function(msg, type) {
  return '<div class="alert flash_'+type+'">'+msg+'<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a></div>';
};

var add_ajax_message = function(msg, type) {
  if (!type) {type = "success"};
  $(".js-notes").append( message_template(msg,type));    
  showNotifications();
};

var show_ajax_message = function(msg, type) {
  if (!type) {type = "success"};
  $(".js-notes").html( message_template(msg,type));    
  showNotifications();
};

var v_nil = function(v){ 
  // console.log(typeof(v), v)
  if (typeof(v) == "object") 
    return v === null || v === undefined || v.value === undefined || v.value === 0;
  else
    return v === null || v === undefined || v === '';
}

var e_nil = function(id){
  return e_val(id) === "";
}

var e_val = function(id){
  let v = document.getElementById(id);
  if (v === null) return "";
  return v.value;
}

var format_date = function(date){
  if (v_nil(date)) {
    date = new Date().toJSON().slice(0,10).replace(/-/g,'-'); 
  }
  if (date.includes('-')){
    return date.split('-').reverse().join('.');
  }
  return date;
}


function getInputSelection(elem){
   if(typeof elem != "undefined"){
    s=elem[0].selectionStart;
    e=elem[0].selectionEnd;
    return elem.val().substring(s, e);
  }else{return '';}
}

$(function() {

  var menu = [
    {name: 'Телефон', fun: function (){$('#lead_phone').val(getInputSelection($('#lead_info')));}}, 
    {name: 'email', fun: function () {$('#lead_email').val(getInputSelection($('#lead_info')));}},
    {name: 'ФИО', fun: function (){$('#lead_fio').val(getInputSelection($('#lead_info')));}}, 
    {name: 'Адрес', fun: function () {$('#lead_address').val(getInputSelection($('#lead_info')));}}
  ];

  $( document ).ajaxError(function( event, jqxhr, settings, thrownError ) {
    if (jqxhr.status != 200) show_ajax_message('error:' + jqxhr.responseText,'error')
  });

  //Calling context menu
  $('#lead_info').contextMenu(menu,{triggerOn:'contextmenu'});

  startTime();
  NProgress.configure({ showSpinner: false, ease: 'ease', speed: 300 });
  NProgress.start();
  NProgress.done();
  plyr.setup();

  $( document ).ajaxStart(function() { NProgress.start(); });  
  $( document ).ajaxStop( function() {
    $('[data-toggle="tooltip"]').tooltip({'placement': 'top', fade: false});
    NProgress.done(); 
    apply_mask();
  });

  $('.progress').hide();
  $('#file').hide();

  $('#tabs').tabs({
    activate: function (event, ui) {
      p = $(".ui-tabs-active a").attr('href');
      window.location.hash = p;
      if ($(p).html() == undefined || ($('.good_group').size()==0 &&  p=='#tabs-4' )) {
        l = $('form').attr('action');
        url = l+"/edit"+p.replace('#','?').replace('-','=')
      //   var request = $.get(url, null, null, 'script')

      //   request.success(function(result) {
      //     console.log(result);
      //   });          
       }
    }
  });

  
  tinyMCE.init({
    selector: '.tinymce textarea', 
    plugins: "textcolor,lists,spellchecker",
    toolbar_items_size : 'small',
    branding: false,
    menubar: '',
    gecko_spellcheck:true,
    toolbar: 'bold italic underline | forecolor backcolor fontsizeselect | bullist numlist '
  });


  $('.timepicker').timepicker({ 'timeFormat': 'H:i' });
  
  $(document).on('focus', '.datepicker', function () {
    $(".datepicker").inputmask('99.99.9999'); 
    $('.ui-datepicker').css('z-index', 99999999999999);
  });

  $('.switcher_a').each(function(){    
    var link = $(this).find('.link_a,.link_c');
    var scale = $(this).find('.scale');
    var handle = $(this).find('.handle');
    var switcher = $(this);
    var details = switcher.parent().find('.details');

    $(scale).click(function(event){
      switcher.toggleClass('toggled');
      link.toggleClass('on');
      link[0].innerHTML = link.attr(link.hasClass('on') ? 'on' : 'off');

      handle.toggleClass('active');

      if (switcher.hasClass('toggled')){
        details.slideDown(300);
      } else {
        details.slideUp(300);
      }

      if (link.hasClass('link_a'))
        sortable_query({only_actual:link.hasClass('on')});
      else{
        if (link.hasClass('on')){
          $('tr.new_client').hide();
          $('tr.ex_client').show();
        }else{
          $('tr.new_client').show();
          $('tr.ex_client').hide();
          $('#project_client_id').val(0);
          $('#project_client_id').trigger("chosen:updated")
        }
      }
      return false;
    });
  });

  $('.nav #develops').addClass('li-right develops');
  $('.nav #options').addClass('li-right options');
  $('[data-toggle="tooltip"]').tooltip({'placement': 'top', fade: false});

  showNotifications();
});


