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
//= require jquery-ui/datepicker
//= require jquery-ui/tabs
//= require jquery-ui  
//= require jquery-ui/accordion
//= require bootstrap-tokenfield
//= require chosen.jquery
//= require jquery.fileupload
//= require nprogress
//= require_tree .


var showNotifications = function(){ 
  $nt = $(".alert"); 
  if (!$nt.hasClass('alert-danger')){
    setTimeout(function() {$nt.removeClass("in").addClass('out'); setTimeout('$nt.remove();',1000);}, 3000);
  }
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




var show_ajax_message = function(msg, type) {
    if (!type) {type = "success"};
    $(".js-notes").html( '<div class="alert fade-in flash_'+type+'">'+msg+'</div>');    
    showNotifications();
};

var fixEncode = function(loc) {
    var h = loc.split('#');
    var l = h[0].split('?');
    return l[0] + (l[1] ? ('?' + ajx2q(q2ajx(l[1]))) : '') + (h[1] ? ('#' + h[1]) : '');
  };

$(function() {

  startTime();


  $('.nav #develops').addClass('li-right develops');
  $('.nav #options').addClass('li-right options');
 
 
   NProgress.configure({
    showSpinner: false,
    ease: 'ease',
    speed: 300
  });

  NProgress.start();
  NProgress.done();

  $( document ).ajaxStart(function() {
      NProgress.start();
  });  

  $( document ).ajaxStop( function() {
    $('[data-toggle="tooltip"]').tooltip({'placement': 'top', fade: false});
    NProgress.done();
  });

  $('[data-toggle="tooltip"]').tooltip({'placement': 'top', fade: false});
  


  $(document).ajaxError(function myErrorHandler(event, xhr, ajaxOptions, thrownError) {
   // alert("There was an ajax error!");
  });
    

$('.progress').hide();
$('#file').hide();
$( "#tabs" ).tabs();
 

  // дата по умолчанию для нового лида - сегодня
  if (!$("#lead_start_date").val()){
	    $("#lead_start_date").val($.datepicker.formatDate('dd.mm.yy', new Date()));
     // $("#lead_status_date").val($.datepicker.formatDate('dd.mm.yy', new Date()));
  }

 $('.sel_val').click(function(){
          if ($(this).hasClass('select_custom_ext')) {
            $(this).removeClass('select_custom_ext');
            $(this).parent().removeClass('select_custom_ext');
          }
          else {
            $(this).addClass('select_custom_ext');
            $(this).parent().addClass('select_custom_ext');
          }
        });

  showNotifications();

  /*$('.menu_sb li a').click(function(){ 
      $('.menu_sb li.active').removeClass("active", 150, "easeInQuint");
      $(this).parent().addClass("active");
      var url = "/" + $(this).attr("controller");
      $.get(url, null, null, "script");
      if (url!="/undefined") setLoc("options"+url);
  });*/

/*  $(document).on('click','#btn-send',function(e) {  
     
    var valuesToSubmit = $('form').serialize();
    var values = $('form').serialize();
    var url = $('form').attr('action');
    var empty_name = false;
    alert(values);
    each(q2ajx(values), function(i, a) {
      if (i.indexOf("[name]") >0  && a=="" ) { empty_name = true; return false; }
    });

    if (!empty_name){
    $.ajax({
        type: "POST",
        url: url, //sumbits it to the given url of the form
        data: valuesToSubmit,
        dataType: 'JSON',  
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},         
        success: function(){
          $.get(url, null, null, "script");
      }
    });
    }
    
    return false; // prevents normal behaviour
  });*/

});


