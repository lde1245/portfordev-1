$(document).ready(function(){
	var member_id = $('#MEMBER_ID').val();
	var member_name = $('#MEMBER_NAME').val();
	// 포트폴리오 상세 출력
	$('.portfolio-list-item').click(function(){
		showDetail();
	});
	// exit 버튼 클릭 시 모달 종료
	$('.exit-detail').click(function(){
		closeDetail();
	});
	// 회색부분 클릭 시 모달 종료
	$('#portfolioModalContainer').click(function(){
		closeDetail();
	});
	// section 클릭 시 모달 종료 방지
	$('#portfolioModalContainer>section').click(function(e){
		e.stopPropagation();
	});
	// 포트폴리오 상세 모달 노출
	function showDetail(){
		$('#portfolioModalContainer').fadeIn();
		$('body').addClass('not-scroll');
		$('#move_top_btn').fadeOut().addClass('never-show');
		doSlick();
		$('.port-slide-list').resize();
		$('.icon-tail-fit').on('click', doActivity);
	}
	// 포트폴리오 상세 모달 종료
	function closeDetail(){
		$('#portfolioModalContainer').fadeOut();
		$('.port-slide-list').slick('unslick');
		$('body').removeClass('not-scroll');
		$('#move_top_btn').removeClass('never-show');
		if($(window).scrollTop() > 500)
		{
			$('#move_top_btn').fadeIn();
		}
		
		$('.icon-tail-fit').off('click', doActivity);
	}
	// 포트폴리오 파일 이미지 변환후 slick 출력
	function doSlick()
	{
		$('.port-slide-list').slick({
			  infinite: false,	// 맨끝이미지에서 끝내지 않고 맨앞으로 이동
			  slidesToShow: 1,	// 화면에 보여질 이미지 갯수
			  slidesToScroll: 1, // 스크롤시 이동할 이미지 갯수
			  arrows: true,	// 화살표
			  vertical:true,	// 세로방향으로 슬라이드
			  verticalSwiping:true,	// 세로방향 슬라이드 가능
			  dots:true,	// 아래 점
			  autoplay: false,	// 자동으로 다음 이미지 보여주기
			  autoplaySpeed:4000,	// 다음 이미지로 넘어갈 시간
			  pauseOnHover:true,	// 마우스 호버시 슬라이드 이동멈춤
			  speed:1000, 			// 다음 이미지로 넘겨질때 걸리는 시간
			  responsive:[
				  {	// 반응형 웹
					  breakpoint:1024,	// 기준화면 사이즈
					  settings:{slidesToShow:1}	// 사이즈에 적용될 설정
				  },
				  {
					  breakpoint:600,
					  settings:{slidesToShow:1}
				  },
				  {
					  breakpoint:500,
					  settings:{slidesToShow:1}
				  }
			  ]
		});
		$('.port-slide-list').on('swipe', function(event, slick, direction){
			console.log('swiped');
		});
		$('.port-slide-item').on('click', function(){
			$('#portfolio-pdf-enlargement-wrap').fadeIn();
			$('#portfolio-pdf-enlargement-wrap').click(function(e){
				e.stopPropagation();
				$('#portfolio-pdf-enlargement-wrap').fadeOut();
			});
		});
	}
	// 여러가지 동작을 시행하는 함수
	function doActivity()
	{
		// 추천하기 클릭 시
		if($(this).children('img').hasClass('recom-icon'))
		{
			recommend_portfolio();
		}
		// 스크랩하기 클릭 시
		else if($(this).children('img').hasClass('scrap-icon'))
		{
			scrap_portfolio();
		}
		// 작성하기 클릭 시
		else if($(this).children('img').hasClass('write-icon'))
		{
			feedback_write(member_id, member_name);
		}
		// 피드백 추천 클릭 시
		else if($(this).children('img').hasClass('feed-recom-icon'))
		{
			var feed_id = $(this).parent().parent().parent().children('.FEEDBACK_ID').val();
			feedback_recommend(member_id, feed_id);
		}
	}
	// 포트폴리오 추천 / 취소
	function recommend_portfolio()
	{
		// 추천이 아직 안되어있을 경우
		if($('.icon-tail-fit>.recom-tail').text() == '추천 하기')
		{
			var recomCnt = Number($('#portfolio-detail-wrap .port-recom-cnt').text()) + 1;
			$('.port-recom-cnt').text(recomCnt);
			$('.recom-icon').attr('src', '/pro/resources/Image/icon/heart-on.png');
			$('.icon-tail-fit>.recom-tail').text('추천 취소');
		}
		// 이미 추천을 했을 경우
		else
		{
			var recomCnt = Number($('#portfolio-detail-wrap .port-recom-cnt').text()) - 1;
			$('.port-recom-cnt').text(recomCnt);
			$('.recom-icon').attr('src', '/pro/resources/Image/icon/heart-off.png');
			$('.icon-tail-fit>.recom-tail').text('추천 하기');
		}
	}
	// 포트폴리오 스크랩 / 취소
	function scrap_portfolio()
	{
		// 스크랩을 아직 안했을 경우
		if($('.icon-tail-fit>.scrap-tail').text() == '스크랩 하기')
		{
			$('.icon-tail-fit>.scrap-icon').attr('src', '/pro/resources/Image/icon/scrap-on.png');
			$('.icon-tail-fit>.scrap-tail').text('스크랩 취소');
		}
		// 스크랩을 이미 했을 경우
		else
		{
			$('.icon-tail-fit>.scrap-icon').attr('src', '/pro/resources/Image/icon/scrap-off.png');
			$('.icon-tail-fit>.scrap-tail').text('스크랩 하기');
		}
	}
	$('.feed-write-cancel').click(feedback_write);
	$('.feedback-write-hide').click(feedback_write);
	// 피드백 작성 클릭 시
	function feedback_write(mid, mname)
	{
		$('.feed-writer-profile-nick').text(mname);
		$('#write-icon-tail').toggleClass('doFeedWrite');
		if($('#feed-icon-tail').hasClass('showFeed'))
		{
			$('#feed-icon-tail').trigger('click');
		}
		if($('.icon-tail-fit>.write-tail').text() == '피드백 작성')
		{
			$('.icon-tail-fit>.write-tail').text('작성 취소');
			$('.portfolio-feedback-list').css('display', 'none');
			$('.portfolio-feedback-header').css('display', 'none');
			$('.feedback-write-container').css('display', 'block');
			$('#FEED_CONTENT').focus();
			if($(window).height() < 740)
				$('#portfolio-feedback-wrap').stop().animate({top: '60%'}, {duration:500,queue:false});
		}
		else
		{
			$('.icon-tail-fit>.write-tail').text('피드백 작성');
			$('#FEED_CONTENT').val('');
			if($(window).height() < 740)
			{
				$('#portfolio-feedback-wrap').stop().animate({top: '100%'}, 500, function(){
					$('.portfolio-feedback-list').css('display', 'block');
					$('.portfolio-feedback-header').css('display', 'block');
					$('.feedback-write-container').css('display', 'none');
				});
			}
			else
			{
				$('.portfolio-feedback-list').css('display', 'block');
				$('.portfolio-feedback-header').css('display', 'block');
				$('.feedback-write-container').css('display', 'none');
			}
		}
	}
	// 피드백 추천 클릭 시
	function feedback_recommend(mid, fid)
	{
		var clicked = $('#FEEDBACK_' + fid).parent().children('.feedback-controller').children('.feedback-recommend').children('.icon-tail-fit');
		if(clicked == null)console.log('null');
		if(clicked.children('.feed-recom-tail').text() == '추천하기')
		{
			clicked.children('.feed-recom-icon').attr('src', '/pro/resources/Image/icon/recom-on.png');
			clicked.children('.feed-recom-tail').text('추천취소');
			clicked.parent().children('.feedback-recommend-cnt').text((Number(clicked.parent().children('.feedback-recommend-cnt').text()) + 1));
		}
		else
		{
			clicked.children('.feed-recom-icon').attr('src', '/pro/resources/Image/icon/recom-off.png');
			clicked.children('.feed-recom-tail').text('추천하기');
			clicked.parent().children('.feedback-recommend-cnt').text((Number(clicked.parent().children('.feedback-recommend-cnt').text()) - 1));
		}
	}
	
	// 포트폴리오 콘솔 > 클릭 시
	$('.drag-activity-menu').click(openActivityMenu);
	function openActivityMenu()
	{
		$(this).toggleClass('openMenu');
	    if($(this).hasClass('openMenu'))
	    {
	    	$('.portfolio-detail-activity').css('display', 'block');
	    	$(this).children('img').attr('src', '/pro/resources/Image/left.png').css('margin-left','-10px');
	    	$(this).stop().animate({left: '0px'}, {duration:400,queue:false});
	    	$('.portfolio-detail-activity').stop().animate({left: '0px'}, {duration:400,queue:false});
	    }
	    else
	    {
	    	$(this).children('img').attr('src', '/pro/resources/Image/right.png').css('margin-left','0px');
	    	$(this).stop().animate({left: '-119px'}, {duration:400,queue:false});
	    	$('.portfolio-detail-activity').stop().animate({left: '-119px'}, {duration:400,queue:false});
	    	
	    }
	}
	
	// portfolio-info-section
	// 프로필 클릭 시
	$('.portfolio-info-writer').click(function(e){
		e.stopPropagation();
		var writerNick = $('.portfolio-info-writer-nick').text();
		if(confirm(writerNick + '님의 프로필로 이동하시겠습니까?'))
			location.href="/pro/profile";
	});
	// 방문하기 img 클릭시
	$('.port-github-img').click(function(e){
		e.stopPropagation();
		var github = $('.port-github-href').val();
		if(confirm(github + '로 이동하시겠습니까?'))
			location.href= github;
	});
	$('.port-site-img').click(function(e){
		e.stopPropagation();
		var site = $('.port-site-href').val();
		if(confirm(site + '로 이동하시겠습니까?'))
			location.href= site;
	});

	// portfolio-info-section show/hide
	// 정보 보기 / 그만 보기 클릭 시
	$('#info-icon-tail').click(info_show_hide);
	function info_show_hide()
	{
		$('#info-icon-tail').toggleClass('showInfo');
		if($('#info-icon-tail').hasClass('showInfo'))
		{
			$('#info-icon-tail').children('img').attr('src', '/pro/resources/Image/icon/info-show-on.png');
			$('#info-icon-tail').children('span').text('그만 보기');
			if($(window).width() > 640)
				$('#portfolio-info-wrap').stop().animate({left: '60%'}, {duration:500,queue:false});
			else
				$('#portfolio-info-wrap').stop().animate({left: '50%'}, {duration:500,queue:false});
		}
		else
		{
			$('#info-icon-tail').children('img').attr('src', '/pro/resources/Image/icon/info-show-off.png');
			$('#info-icon-tail').children('span').text('정보 보기');
			$('#portfolio-info-wrap').stop().animate({left: '100%'}, 500, function(){
				$('#portfolio-info-wrap').scrollTop(0);
			});
		}
	}
	// portfolio-feeback-section show/hide
	// 피드백 보기 / 그만 보기 클릭 시
	$('#feed-icon-tail').click(feed_show_hide);
	function feed_show_hide()
	{
		$('#feed-icon-tail').toggleClass('showFeed');
		if($('#write-icon-tail').hasClass('doFeedWrite'))
		{
			$('#write-icon-tail').trigger('click');
		}
		if($('#feed-icon-tail').hasClass('showFeed'))
		{
			$('.portfolio-feedback-list').css('display', 'block');
			$('.portfolio-feedback-header').css('display', 'block');
			$('.feedback-write-container').css('display', 'none');
			$('#feed-icon-tail').children('img').attr('src', '/pro/resources/Image/icon/feed-show-on.png');
			$('#feed-icon-tail').children('span').text('그만 보기');
			$('#portfolio-feedback-wrap').stop().animate({top: '100px'}, {duration:500,queue:false});
		}
		else
		{
			$('#feed-icon-tail').children('img').attr('src', '/pro/resources/Image/icon/feed-show-off.png');
			$('#feed-icon-tail').children('span').text('피드백 보기');
			$('#portfolio-feedback-wrap').stop().animate({top: '100%'}, 500, function(){
				$('.portfolio-feedback-list').scrollTop(0);
			});
		}
	}
	$('.portfolio-feedback-hide').click(feed_show_hide);
	
	// 창 크기 조절 할 경우
	$(window).resize(function(){
		if($(window).height() > 740 && $(window).height() < 1240)
		{
			if($(window).width() < 778)
				$('#portfolio-feedback-wrap').css('top', '70%');
			else
				$('#portfolio-feedback-wrap').css('top', '65%');
		}
		else
		{
			if($(window).height() <= 740)
			{
				if($('#feed-icon-tail').hasClass('showFeed'))
				{
					$('#portfolio-feedback-wrap').css('top', '100px');
					$('#feed-icon-tail').trigger('click');
				}
				else
				{
					$('#portfolio-feedback-wrap').css('top', '100%');
				}
				if($('#write-icon-tail').hasClass('doFeedWrite'))
				{
					$('#write-icon-tail').trigger('click');
				}
			}
			else
			{
				$('#portfolio-feedback-wrap').css('top', '845px');
			}
			
		}
		if($(window).width() > 778)
		{
			$('#portfolio-info-wrap').css('left', '70%');
		}
		else
		{
			if($('#info-icon-tail').hasClass('showInfo'))
			{
				if($(window).width() > 640)
					$('#portfolio-info-wrap').css('left', '60%');
				else
					$('#portfolio-info-wrap').css('left', '50%');
				$('#info-icon-tail').trigger('click');
			}
			else
			{
				$('#portfolio-info-wrap').css('left', '100%');
			}
		}
	});
	
	function slickCheck(){
		var slickInfoObj={
			variableWidth:true,  //width 크기가 서로 다르다는 것을 알림.
			dots: false,
			swipe:false,
			cssEase: 'ease-out',
			infinite: true,
			slidesToShow:6, //한 화면에 보여줄 리스트 개수
			slidesToScroll:1
	}
		// 슬릭이 진행중인지 css로 체크
		if( $('.port-slide-list').hasClass('slick-initialized') )
		{
			$('.port-slide-list').slick('unslick');//슬릭해제
		}
		else
		{
			$('.port-slide-list').slick(slickInfoObj);
		}
	}
	// $('.add-remove').slick('slickRemove', null, null, true);
}); // document.ready end