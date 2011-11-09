(function(){

//	Массив имён картинок для слайдшоу
	var IMAGES = [
		['food1.jpg', 'food3.jpg', 'food4.jpg', 'food5.jpg'],
		['private1.jpg', 'private2.jpg', 'private3.jpg', 'private4.jpg'],
		['biz1.jpg', 'biz2.jpg', 'biz3.jpg', 'biz4.jpg']
	];
	
//	Простая предзагрузка изображений для слайдшоу
	var imgPreload = [];
	for( var i = 0; i < IMAGES.length; i++ ){
		imgPreload[i] = [];
		for( var j = 0; j < IMAGES[i].length; j++ ){
			imgPreload[i][j] = new Image(545, 190);
			imgPreload[i][j].src = '/img/ill/' + IMAGES[i][j];
		}
	}
	
	$(function(){
		//	Телефоны	
		$('.b-contacts .tabs-controls').idTabs();
		
		$('#promo .specialization').idTabs();
		$('#promo .illustration').slideShow(IMAGES,{
			linksSelector: '#promo .specialization a',
			savePositions: true
		});
		
		simpleAccordion();
	});
	
//	Меню-аккордион, используется в меню каталога
	function simpleAccordion(){
		$('#navigation .catalog > li').not('.active-parent').children('ul').hide();
		$('#navigation .catalog > li > a:not(:only-child), #navigation .catalog > li > em:not(:only-child) a').attr('class', 'dashed');
		$('#navigation .catalog > li > a, #navigation .catalog > li > em').not(':only-child').click(function(){
			$(this).parents('ul').children('li').children('ul').hide();
			$(this).siblings('ul').show();
			return false;
		});
	};
})();

/* idTabs ~ Sean Catchpole - Version 1.0 */
(function($){$.fn.idTabs=function(){var s={"start":null,"return":false,"click":null};for(var i=0;i<arguments.length;++i){var n={},a=arguments[i];switch(typeof a){case"object":$.extend(n,a);break;case"number":break;case"string":n.start=a;break;case"boolean":n["return"]=a;break;case"function":n.click=a;break};$.extend(s,n)}var d=this;var e=$("a[@href^='#']",this).click(function(){if($("a.selected",d)[0]==this)return s["return"];var a="#"+this.href.split('#')[1];var b=[];var c=[];$("a",d).each(function(){if(this.href.match(/#/)){b[b.length]=this;c[c.length]="#"+this.href.split('#')[1]}});if(s.click&&!s.click(a,c,d))return s["return"];for(i in b){$(b[i]).removeClass("selected");$(b[i]).parent().removeClass("selected")};for(i in c)$(c[i]).hide();$(this).addClass("selected");$(this).parent().addClass("selected");$(a).show();$(this).blur();return s["return"]});var f;if(typeof s.start=="number"&&(f=e.filter(":eq("+s.start+")")).length)f.click();else if(typeof s.start=="string"&&(f=e.filter("[@href='#"+s.start+"']")).length)f.click();else if((f=e.filter(".selected")).length)f.removeClass("selected").click();else if(location.hash.length)e.filter("[@href='"+location.hash+"']").click();else e.filter(":first").click();return this};$(function(){$(".idTabs").each(function(){$(this).idTabs()})})})(jQuery);

/* slideShow ~ Золотов Никита (nikita at infolio.ru) */
$.fn.slideShow=function(b,c){var d={imagesDir:'/img/ill/',showTime:5000,changeTime:800,linksSelector:'',savePositions:false};$.extend(d,c);return this.each(function(){var a=$(this),img=$('img',this),categoriesLinks=$(d.linksSelector),currentInterval,currentImgI=0,currentImgJ=1,savedIndexes=[1,0,0];if(typeof b=='object'){if(categoriesLinks.length){assignEvents()}start()}function start(){currentInterval=setInterval(function(){changeImg()},d.showTime)};function changeImg(){img.fadeOut(d.changeTime,function(){$(this).attr('src',d.imagesDir+b[currentImgI][currentImgJ]);$(this).fadeIn(d.changeTime,function(){if(currentImgJ>=b[currentImgI].length-1){currentImgJ=0}else{currentImgJ++}if(d.savePositions){savedIndexes[currentImgI]=currentImgJ}})})};function assignEvents(){categoriesLinks.click(function(){currentImgI=categoriesLinks.index(this);if(d.savePositions){currentImgJ=savedIndexes[currentImgI]}else{currentImgJ=0}clearInterval(currentInterval);changeImg();currentInterval=setInterval(function(){changeImg()},d.showTime)})}})};