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
//= require jquery.timepicker
//= require nprogress
//= require_tree .

function to_sum(d){ 
    return d.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1 "); 
}

function intFromSum(sum){
  return parseInt(sum.replace(' ',''))
}

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

var delay = (function(){
  var timer = 0;
  return function(callback, ms){
    clearTimeout (timer);
    timer = setTimeout(callback, ms);
  };
})();


var show_ajax_message = function(msg, type) {
    if (!type) {type = "success"};
    $(".js-notes").html( '<div class="alert fade-in flash_'+type+'">'+msg+'</div>');    
    showNotifications();
};


$(function() {

  startTime();

  $('.timepicker').timepicker({ 'timeFormat': 'H:i' });

 $('.switcher_a').each(function(){
        var switcher = $(this);
        var link = $(this).find('.link_a');
        var scale = $(this).find('.scale');
        var handle = $(this).find('.handle');
        var details = switcher.parent().find('.details');

        $(link).click(function(event){
            switcher.toggleClass('toggled');
            link.toggleClass('on');
            var attr = link.hasClass('on') ? 'on' : 'off'
            link[0].innerHTML = link.attr(attr);
            handle.toggleClass('active');

            if(switcher.hasClass('toggled')){
                details.slideDown(300);
                
            } else {
                details.slideUp(300);
           
            }
            sortable_query({only_actual:link.hasClass('on')});
            return false;
        });

        $(scale).click(function(event){
            switcher.toggleClass('toggled');
            link.toggleClass('on');
            link[0].innerHTML = link.attr(link.hasClass('on') ? 'on' : 'off');
            handle.toggleClass('active');

            if(switcher.hasClass('toggled')){
                details.slideDown(300);
            } else {
                details.slideUp(300);
            }
            sortable_query({only_actual:link.hasClass('on')});
            return false;
        });
       
        

    });



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

});


