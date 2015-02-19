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
//= require jquery-ui
//= require jquery-ui/datepicker
//= require jquery_ujs
//= require twitter/bootstrap
//= require bootstrap-tokenfield
//= require bootstrap
//= require chosen.jquery
//= require bootstrap-datepicker
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.ru.js

window.setTimeout(function() {
  $(".fade").fadeTo(500, 0).slideUp(500, function(){
      $(this).remove();
  });
}, 3000);

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
	document.getElementById('date_txt').innerHTML=h+":"+m+":"+s;
	t=setTimeout('startTime()',500);
}

function updateDev(){
  $.get( "develops/", {'search':$("#search").val(),'show':$(".active").attr('show')},null,"script");
}

$(function() {

  //alert(21);
  startTime();
  $(".chosen-select").chosen({ width: '350px' });
  //alert(24);

  // форматы календарей
  $("#datepicker").datepicker({format: "yyyy-mm-dd", weekStart: 1, autoclose: true, language: "ru", todayHighlight: true});
  $("#datepicker2").datepicker({format: "yyyy-mm-dd", weekStart: 1, autoclose: true, language: "ru", todayHighlight: true});

  // дата по умолчанию для нового лида - сегодня
  if (!$("#datepicker2").val()){
	    $("#datepicker2").val($.datepicker.formatDate('yy-mm-dd', new Date()));
  }

  $('#develops_search .btn').click(function(){setTimeout( 'updateDev()' ,400);});

  $("#develops_search input").keyup(function() {

    var c= String.fromCharCode(event.keyCode);
    var isWordcharacter = c.match(/\w/);
    
    if (isWordcharacter || event.keyCode ==8){
    	s=1;
    	setTimeout( 'updateDev()' ,400);
    }
    return false;
  });


// меняем отметки coder и boss непосредственно в index
    $('#develops_list').on('click','span.check_img', function(){
//      alert(228);
		if ($(this).hasClass("checked")){
        	$(this).removeClass("checked");
			checked = false;
     	}else{
        	checked = true;
			$(this).addClass("checked");
     	};

     	dev_id  = $(this).attr('developid');
     	chk 	= $(this).attr('chk');


     	 $.ajax({
	 		url: "/ajax/dev_check",
	 		data: {'develop_id':dev_id,'field':chk, 'checked': checked},
	 		type: "POST",
	 		beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},	 
	  		success: function(){
	   			$(this).addClass("done");
	  		}
	 	});
  });


  $('span.btn-sm').click(function(){
  	comment = $("#comment_comment").val();
  	lead_id = $(this).attr('leadid');

	comment_id = $(".microposts p:first").attr('leadid');
	if (comment=='') return;
  	//return;
  	$.ajax({
	 url: "/ajax/add_comment",
	 data: {'comment':comment,'lead_id':lead_id},
	 type: "POST",
	 beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},	 
	  success: function(){
	   $("#comment_comment").val("");
	   $.get('/leads/'+lead_id+'/edit', "", null, "script");
	   $('.panel-body').scrollTop(-9999);
	  }
	 });


  });



});


