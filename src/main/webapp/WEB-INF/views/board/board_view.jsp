<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="../main/navbar.jsp" />
<meta charset="UTF-8">
<title>게시판 뷰</title>
<style>
hr {
	margin : 5px;
}
span {
	width: 20px;
}
#no {
	display: none;
}
#count {
	position: relative;
	top: -10px;
	left: -10px;
	background: orange;
	color: white;
	border-radius: 30%;
}
.container {
	padding-top: 55px;
}
#content {
	width:100%
}
.title {
	font-size : 20pt;
	font-weight : bold;
}
</style>
<script>
	function insert_reco(board_id, member_id) {
		$.ajax({
			type : "post",
			url : '/pro/reco_add',
			data : {
				"board_id" : board_id,
				"member_id" : member_id
			},
			success : function(rdata) {
				$("#reco_button").empty();
				var text = '<img id = "reco_img" src="resources/Image/icon/heart-fill.svg" width ="18px">';
				$("#reco_button").append(text+rdata);
			},
			error : function() {
				alert("추천에 실패했습니다.(관리자에게 문의하세요.)");
			}
		});
	};
	function delete_reco(board_id, member_id) {
		$.ajax({
			type : "post",
			url : '/pro/reco_delete',
			data : {
				"board_id" : board_id,
				"member_id" : member_id
			},
			success : function(rdata) {
				$("#reco_button").empty();
				var text = '<img id = "reco_img" src="resources/Image/icon/heart.svg" width ="18px">';
				$("#reco_button").append(text+rdata);
			},
			error : function() {
				alert("추천 취소에 실패했습니다.(관리자에게 문의하세요.)");
			}
		});
	};
	$(function() {
		// 제목(카테고리)
		if("${board_data.BOARD_CATEGORY}"=="0") {
			$('#h3_category').text("자유게시판");
		} else if("${board_data.BOARD_CATEGORY}"=="1"){
			$('#h3_category').text("스터디");
		} else {
			$('#h3_category').text("Q&A");
		}
		
		
		
		<c:forEach var="recos" items="${board_reco_list}">
			if("${recos.MEMBER_ID}" =="${id}") {
				$("#reco_img").attr("src","resources/Image/icon/heart-fill.svg");
			}
		</c:forEach>
		
		$("#reco_button").click(function() {
			// 추천아님 -> 추천
			if($("#reco_img").attr("src") =="resources/Image/icon/heart.svg") {
				insert_reco($("#board_id").val(), "${id}");
			} else { // 추천 -> 추천아님
				delete_reco($("#board_id").val(), "${id}");
			}
			
		});
		
		
		$("#write").click(function() {
			buttonText = $("#write").text();
			content = $("#content").val();
			if($("#loginid").val() == "") {
				alert("로그인을 먼저 해주세요");
				return false;
			}
			if(content == "") {
				alert("댓글을 입력하세요");
				$("#content").focus();
				return false;
			}
			if (buttonText == "등록") { //추가 하는 경우
				url = "/pro/comment_add";
				data = {
					"BOARD_CO_CONTENT" : content,
					"MEMBER_ID" : $("#loginid").val(),
					"BOARD_ID" : $("#board_id").val()
				};
			} else { // 수정하는 경우
				url = "/pro/comment_update";
				data = {
					"BOARD_CO_ID" : $("#comment_id").val(),
					"BOARD_CO_CONTENT" : content
				};
				$("#write").text("등록");
			}
			$.ajax({
				type : "post",
				url : url,
				data : data,
				success : function(result) {
					$("#content").val('');
					if (result == 1) {
						getList();
					}
				}
			})
		})
		function getList() {
			$.ajax({
						type : "get",
						url : "/pro/comment_list",
						data : {
							"BOARD_ID" : $("#board_id").val()
						},
						dataType : "json",
						cache : false,
						success : function(data) {
							if (data.leng > 0) {
								$("#comment tbody").empty();
								output = '';
								$.each(data.comment_list, function(index, item) {
										output += "<tr><td>"
										       + item.member_NAME
										       + "<span style='font-size: 10pt'><img src='resources/Image/icon/award.svg' alt='act' width ='14' height='14'>"
										       + item.member_ACT
										       + "</span> <br><span style='display:none'>"
										       + item.board_CO_ID
										       + "</span> " + item.board_CO_DATE;
										       if($("#loginid").val() == item.member_ID) {
												    output += "<span class='comment_update' style='font-size: 10pt'>"
												           + "<img src='resources/Image/icon/pencil.svg' alt='update' width='14' height='14'></span>"
												           + "<span class='comment_remove' style='font-size: 10pt'>"
												           + "<img src='resources/Image/icon/trash.svg' alt='remove' width='14' height='14'></span>";
											   }
										output += "<hr><span>" + item.board_CO_CONTENT +"</span></td></tr>";
								});
								$("#comment tbody").append(output);
							} else {
								$("#comment tbody").empty();
							}
							$("#comment_length").text('댓글 ('+data.leng+'개)');
						}, error : function() {
							alert("댓글 불러오기 실패");
						}
			});
		};
		// 수정버튼 클릭경우(댓글)
		$(document).on('click', '.comment_update', function() {
			before = $(this).next().next().next().text(); 
			$("#content").focus().val(before); 
			num = $(this).prev().text();
			$("#comment_id").val(num);
			$("#write").text("수정"); 
		});
		// 삭제버튼 클릭경우(댓글)
		$(document).on('click', '.comment_remove', function() {
			num = $(this).prev().prev().text();
			$.ajax({
				type : "get",
				url : "/pro/comment_delete",
				data : {
					"BOARD_CO_ID" : num
				},
				success : function(result) {
					if (result == 1)
						getList();
				}
			})
		})
		
	})
</script>
</head>
<body>
	<input type="hidden" id="loginid" value="${id}">
	<input type="hidden" id="board_id" value="${board_data.BOARD_ID}">
	<div class="container">
		<h3 id ="h3_category" class="float-left"></h3> 	
		<table class="table table-bordered">
			<thead>
				<tr>
					<td>
						<a href="/pro/profile?id=${board_data.MEMBER_ID}">${board_data.MEMBER_NAME}
							<span style ="font-size:10pt">
								<img src="resources/Image/icon/award.svg" alt="act" width="14" height="14">${board_data.MEMBER_ACT}
							</span>
							<br>
							&#35;<span style="font-weight:bold">board_data.BOARD_ID</span><span style="font-size:9pt"> ${board_data.BOARD_DATE}에 작성됨</span>
						</a>
					</td>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>
						<div class="title">
							<c:if test="${board_data.BOARD_RE_LEV !=0}">
								<c:forEach var="a" begin="1" end="${board_data.BOARD_RE_LEV}" step="1">
									[re]
								</c:forEach>
							</c:if>
							${board_data.BOARD_SUBJECT}
						</div>
						<hr>
						<div>${board_data.BOARD_CONTENT}</div>
					</td>
				</tr>
				<c:if test="${!empty board_file_list}">
				<tr>
					<td>
						<div>첨부파일</div>
						<div>
						<c:forEach var="files" items="${board_file_list}">
							<img src="resources/Image/down.png" width ="12px">
							<a href="board_file_down?filename=${files.BOARD_FILE}&original=${files.BOARD_FILE_ORIGINAL}">
								${files.BOARD_FILE_ORIGINAL}</a>
							&#32;/&#32;
						</c:forEach>
						</div>
					</td>
				</tr>
				</c:if>
			<tr>
				<!-- 버튼 모음 -->
				<td class="center">
					<button id="reco_button"style="background:transparent"><img id = "reco_img" src="resources/Image/icon/heart.svg" width ="18px"> ${board_data.BOARD_RECO}</button>
					<button style="background:transparent">
						<img src="resources/Image/icon/eye.svg" width ="20px"> ${board_data.BOARD_READCOUNT}
					</button>
					<!-- 답변 -->
					<a href="/pro/board_reply_view?id=${board_data.BOARD_ID}">
						<button class="btn btn-primary">답변</button>
					</a>
					<c:if test="${board_data.MEMBER_ID == id}">
						<!-- 수정 -->
						<a href="BoardModifyView.bo?num=${board_data.BOARD_ID}">
							<button style="background:transparent"><img src="resources/Image/icon/pencil.svg" width ="25px"></button>
						</a>
						<!-- 삭제 -->
						<a href="#">
							<button style="background:transparent" data-toggle="modal"
								data-target="#myModal"><img src="resources/Image/icon/trash.svg" width ="25px"></button>
						</a>
					</c:if> 
					<a href="/pro/board_list">
						<button class="btn btn-primary">목록</button>
					</a>
				</td>
			</tr>
			</tbody>
		</table>
		<div id="comment">
			<table class="table table_striped">
				<thead>
					<tr>
						<td id="comment_length">댓글 (${board_data.BOARD_COMMENT}개)</td>
					</tr>
				</thead>
				<tbody>
					<c:if test="${!empty comment_list}">
					<c:forEach var="comments" items="${comment_list}">
					<tr>
						<td>
							${comments.MEMBER_NAME}
							<span style ="font-size:10pt">
								<img src="resources/Image/icon/award.svg" alt="act" width="14" height="14">${comments.MEMBER_ACT}
							</span>
							<br>
							<span style="display:none">${comments.BOARD_CO_ID}</span> ${comments.BOARD_CO_DATE}
							<!-- 수정, 삭제 -->
							<c:if test="${comments.MEMBER_ID == id}">
								<span class="comment_update" style ="font-size:10pt">
									<img src="resources/Image/icon/pencil.svg" alt="update" width="14" height="14">
								</span>
								<span class="comment_remove" style ="font-size:10pt">
									<img src="resources/Image/icon/trash.svg" alt="remove" width="14" height="14">
								</span>
							</c:if>
							<hr>
							<span>${comments.BOARD_CO_CONTENT}</span>
						</td>
					</tr>
					</c:forEach>
					</c:if>
				</tbody>
				<tfoot>
					<tr>
						<td>
							<span style="color:gray">총 80자까지 가능합니다.</span>
							<textarea class="float-left" rows="2" name="content" id="content" maxLength="80"></textarea>
							<input id ="comment_id" type="hidden"></input>
							<button type="button" id="write" class="btn btn-info float-right">등록</button>
						</td>
					</tr>
				</tfoot>
			</table>
		</div>
		
		
		<%-- delete 모달 --%>
	<div class="modal" id="myModal">
			<div class="modal-dialog">
				<div class="modal-content">


					<!-- Modal body -->
					<div class="modal-body">
						<form name="deleteForm" action="BoardDeleteAction.bo"
							method="post">
							<div class="form-group">
								<label for="pwd">비밀번호</label> 
								<input type="password"
									class="form-control" placeholder="Enter password"
									name="BOARD_PASS" id="board_pass">
							</div>
							<button type="submit" class="btn btn-primary">Submit</button>
							<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
						</form>
					</div>
				</div>
			</div>
		</div> 
	</div>
</body>
</html>