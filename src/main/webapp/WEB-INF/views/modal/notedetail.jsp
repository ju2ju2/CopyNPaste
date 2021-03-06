<%-- modal>>
@JSP : notedetail.jsp
@Date : 2018.10.11
@Author : 우나연
@Desc : 노트 상세보기 db값 입력(우나연, 10월 17일)
      댓글 신고 클릭시 모달창 추가, OK버튼 누를 때 스위트알럳 뜸. 버튼색은 추후 수정 필요.(이주원, 10월 12일)
      스위트 알럿 cdn방식이 아닌 js와 css를 임포트 하는 방식으로 변경. (이주원, 10월 15일)
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="se"   uri="http://www.springframework.org/security/tags"%>

<se:authentication property="name" var="loginuser" />
<se:authentication property="authorities" var="role" />

<script>
   $(document).ready(function() {	   
      $(document).on('hidden.bs.modal', '.modal', function (e) {
           var modalData = $(this).data('bs.modal');
           if (modalData && modalData.options.remote) {
             $(this).removeData('bs.modal');
             $(this).find(".modal-content").empty();
             $(e.target).removeData("bs.modal").find(".modal-content").empty();
           }
      });
      
      var userEmail = '${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}';
      var role='${sessionScope.SPRING_SECURITY_CONTEXT.authentication.authorities}';
   
      
      ///* 작성,수정페이지에서 에디터기에 추가 */
      $('#addToNoteBtn').click(function addToNote(e) {
            $(".modal").modal("hide");
            var editor = tinyMCE.activeEditor;
            var path = "${pageContext.request.contextPath}/note/noteDetail.htm?noteNum="+${note.noteNum}
             var noteContent = $('#noteContent').html();
             editor.dom.add(editor.getBody(), 'p', {}, noteContent+ "<br>");
             var userEmail = '${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}';
             if ('${note.userEmail}'!=userEmail){
                var noteOrigin ='<br/><br/> 출처:'+ path+" ["+'${note.userNick}'+ "]";
                editor.dom.add(editor.getBody(), 'p', {}, noteOrigin + "<br>");
             }
         });
      
      //노트 pdf 파일 다운로드
      $('#downloadPdfBtn').click(function downloadPdf(e) {
         swal({
              title: "파일을 다운로드 하시겠습니까?",
              type: 'warning',
              showCancelButton: true,
              confirmButtonClass : "btn-danger btn-sm",
              cancelButtonClass: "btn btn-sm",
              confirmButtonText: 'OK',
              closeOnConfirm: true
            },
            function(){
               location.href="${pageContext.request.contextPath}/note/downloadNotePdf.do?noteNum=${note.noteNum}";
               });
            return false;
         });
      
      //노트 이메일 전송
      $('#emailNoteBtn').click(function emailNote() {
         swal({
              title:'<span class="title">이메일전송</span>',
              text: '<form id="email">'+
                  '<input type="email" class="form-control mb-10" id="noteEmailTo" placeholder="노트를 전송할 이메일 주소를 입력하세요"/>'+
                  '</form>'
              ,
              html: true,
              inputAttributes: { autocapitalize: 'off' },
              showCancelButton: true,
              confirmButtonText : "OK",
              confirmButtonClass : "btn-danger btn-sm",
              cancelButtonClass : "btn btn-sm"
         },
         function(){
            $.ajax ({
                  url: "${pageContext.request.contextPath}/note/emailNote.json",
                  type: "POST",
                  data: {   'noteNum': ${note.noteNum},
                        'noteEmailTo' : $('#noteEmailTo').val() }//
            }).done(function(result) {
               swal({type: "success",
                    title: '이메일이 전송되었습니다.',
                       confirmButtonClass : "btn-danger btn-sm",
                    closeOnConfirm: true
               },
               function(){
                  
               })
               
            
            })
            .fail(function(request,status,error){
                    console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                });
         });
      return false;
   });
      
      //노트 스크랩 등록
      $('#scrapNoteBtn').click(function scrapNote(e) {
         var path = "${pageContext.request.contextPath}/note/noteDetail.htm?noteNum="+${note.noteNum}
         var noteContent = $('#noteContent').html();
         var noteOrgin ='<br/><br/> 출처:'+ path+"["+'${note.userNick}'+ "]";
         swal({
              title: "노트를 스크랩 하시겠습니까?",
              type: 'warning',
              showCancelButton: true,
              confirmButtonClass : "btn-danger btn-sm",
              cancelButtonClass: "btn btn-sm",
              confirmButtonText: 'OK',
              closeOnConfirm: false
            },
            function(){
               $.ajax ({
                  url: "${pageContext.request.contextPath}/note/scrapNote.json",
                  type: "POST",
                  data: {'noteNum': ${note.noteNum},
                        'noteContent': noteContent + noteOrgin
                        }
                  })//다운로드 받을 html
                  .done(function(result) {
                     swal({type: "success",
                          title: '노트가 스크랩 폴더에 \n저장되었습니다.',
                             confirmButtonClass : "btn-danger btn-sm",
                          closeOnConfirm: true
                     },
                     function(){
                     
                     })
                                 
                  })
                  .fail(function(request,status,error){
                          console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                      });
               });
            return false;
         });

      
      //노트삭제
      $('#deleteNoteBtn').click(function deleteNote(e) {
         swal({
              title: "정말 삭제하시겠습니까?",
              text: "삭제 후에는 복구할 수 없습니다.",
              type: 'warning',
              showCancelButton: true,
              confirmButtonClass : "btn-danger btn-sm",
              cancelButtonClass: "btn btn-sm",
              confirmButtonText: 'OK',
              closeOnConfirm: false
            },
            function(){
               $.ajax ({
                  url: "${pageContext.request.contextPath}/note/deleteNote.json",
                  type: "POST",
                  dataType: "json",
                  data: {   'noteNum': ${note.noteNum} }//
               }).done(function(result) {
                  swal({type: "success",
                       title: '노트가 삭제되었습니다.',
                          confirmButtonClass : "btn-danger btn-sm",
                      	 closeOnConfirm: true
                  },
                  function(){
                     location.reload();
                  })
                  
               
               })
               .fail(function(request,status,error){
                       console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                   });
            });
         return false;
      });

      //노트 신고
      $('#noteReportForm').click(function noteReport() {
         swal({
              title:'<span class="title">노트신고</span>',
              text: '<form style="font-size:15px;"><br><p><strong>작성자</strong> <span id="noteWriter">${note.userNick}</span></p>'+
                  '<input type="hidden" value=${note.userEmail}/>'+
                  '</p><p style="padding-top: 10px;">'+
                  '<strong>신고 사유</strong>&ensp; <select name="causeCategory"'+
                  '   id="causeCategory">'+
                  '   <option >신고 사유를 선택하세요</option>'+
                  '   <option value="NR01">광고/음란성 게시물</option>'+
                  '   <option value="NR02">욕설 및 부적절한 언어</option>'+
                  '   <option value="NR03">회원비방/싸움조장</option>'+
                  '   <option value="NR04">명예훼손/저작권 침해</option>'+
                  '   <option value="NR00">기타</option>'+
                  '</select></p> <p style="padding-top: 10px;"><strong>신고 사유 상세</strong>'+
                  '</p><textarea rows="5" id="causeText"class="form-control textarea noresize"'+
                  'placeholder="신고 사유를 입력하세요"></textarea><br>'+
                  '<p align="center"><strong>위와 같은 내용으로 <br/>해당 노트를 신고하시겠습니까?</strong>'+
                  '</p></div></form>'
              ,
              html: true,
              inputAttributes: { autocapitalize: 'off' },
              showCancelButton: true,
              confirmButtonText : "OK",
              confirmButtonClass : "btn-danger btn-sm",
              cancelButtonClass : "btn btn-sm",
              closeOnConfirm: false
         },
         function(){
            $.ajax ({
               url : '${pageContext.request.contextPath}/etc/insertReport.json',
               type: "POST",
               data : {
                  "userEmail" : userEmail,
                  "noteNum" : ${note.noteNum},
                  "noteOrCommCode" : 'NC00',//노트신고코드
                  "reportCauseCode" : $("#causeCategory option:selected").val(),
                  "reportContent" : $('#causeText').val()  
                  },
            }).done(function(result) {
               swal({type: "success",
                    title: '관리자 확인 후 블라인드 처리됩니다.',
                       confirmButtonClass : "btn-danger btn-sm",
                    closeOnConfirm: true
               },
               function(){
               
               })
               
            
            })
            .fail(function(request,status,error){
                    console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                });
         });
      return false;
   });
      
   /* 비회원인 경우 마우스 down 시 로그인 팝업 */
   var session = ('${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal}');

   $('#noteContent').mousedown(function(){   
      if(session == '') {
         $('#loginModal').show();   
            swal({
              title: "",
              text: '로그인 후 다양한 기능을 이용할 수 있습니다. \n로그인 페이지로 이동 하시겠습니까?',
              type: "warning",
              showCancelButton: true,
              confirmButtonClass: "btn-danger btn-sm",
              confirmButtonText : "OK",
              cancelButtonClass: "btn btn-sm",
              closeOnConfirm: false,
            }
         , function () {
            location.href = "${pageContext.request.contextPath}/login.htm"
               
      }) 
      }
   });

//끝   
});
</script>
<!-- modal-header -->
<div class="modal-header">
   <button type="button" class="close" data-dismiss="modal">&times;</button>
   <br>
   <!-- 노트제목 -->
   <h2 class="modal-title">${note.noteTitle}</h2>
   <div class="row mt-10" >
      <div class="col-xs-6"></div>
      <div class="col-xs-6">
         <!-- 작성자/작성일 -->
         <strong>${note.userNick}</strong>&nbsp;|&nbsp;${note.noteDate}&nbsp;|&nbsp;#Ref : ${note.noteCount}
         
      </div>
   </div>
   <div class="row">
      <div class="col-xs-6"></div>
      <div class="col-xs-6"></div>
   </div>
</div>
<!-- modal-body-->
<div class="modal-body">
   <div class="">
      <div class="">
         <div class="row">
            <!-- 본문 -->
            <div class="text-left col-sm-12" id="noteContent">${note.noteContent}</div>
            <div class="row">
               <br> <br> <br> <br>
               <div class="col-sm-9"></div>
               <div class="col-sm-3">
                  <strong>
                  <se:authorize access="hasAnyRole('ROLE_USER', 'ROLE_ADMIN')"> <!-- 회원인 경우 아이콘 노출 -->
                  <c:choose>
                     <c:when test="${note.noteScrap eq 0 and note.userEmail==loginuser}">
                         <a href="${pageContext.request.contextPath}/note/updateNote.htm?noteNum=${note.noteNum}">
                            <i class="far fa-edit notewrite" title="노트 수정"></i> &nbsp;</a> 
                         <a id="emailNoteBtn"><i class="far fa-envelope notewrite" title="노트 이메일로 발송"></i> &nbsp;</a> 
                         <a id="downloadPdfBtn"><i class="fas fa-arrow-down notewrite" title="노트 다운로드"></i> &nbsp;</a> 
                         <a id="deleteNoteBtn"><i class="fas fa-trash notewrite" title="노트 삭제"></i> &nbsp;</a> 
                     </c:when>
                     <c:when test="${note.noteScrap eq 1 and note.userEmail==loginuser}"><!-- 스크랩한 글일때 수정버튼>>새노트작성  -->
                        <a href="${pageContext.request.contextPath}/note/insertWithOtherNote.htm?noteNum=${note.noteNum}">
                           <i class="far fa-edit notewrite" title="이 노트를 이용해 새 노트 작성"></i> &nbsp;</a> 
                         <a id="emailNoteBtn"><i class="far fa-envelope notewrite" title="노트 이메일로 발송"></i> &nbsp;</a> 
                         <a id="downloadPdfBtn"><i class="fas fa-arrow-down notewrite" title="노트 다운로드"></i> &nbsp;</a> 
                         <a id="deleteNoteBtn"><i class="fas fa-trash notewrite" title="노트 삭제"></i> &nbsp;</a> <!-- 스크랩글 삭제 -->
                         <a id="noteReportForm"><i class="fas fa-flag notewrite" title="노트 신고"></i> &nbsp;</a> 
                     </c:when>
                     <c:when test="${role=='[ROLE_ADMIN]'}">
                          <a href="${pageContext.request.contextPath}/note/insertWithOtherNote.htm?noteNum=${note.noteNum}">
                             <i class="far fa-edit notewrite" title="이 노트를 이용해 새 노트 작성"></i> &nbsp;</a> 
                         <a id="emailNoteBtn"><i class="far fa-envelope notewrite" title="노트 이메일로 발송"></i> &nbsp;</a> 
                         <a id="downloadPdfBtn"><i class="fas fa-arrow-down notewrite" title="노트 다운로드"></i> &nbsp;</a> 
                         <a id="scrapNoteBtn"><i class="fas fa-archive notewrite" title="노트 스크랩"></i> &nbsp;</a>
                         <a id="deleteNoteBtn"><i class="fas fa-trash notewrite" title="노트 삭제"></i> &nbsp;</a> 
                     </c:when>
                     <c:otherwise>
                          <a href="${pageContext.request.contextPath}/note/insertWithOtherNote.htm?noteNum=${note.noteNum}">
                             <i class="far fa-edit 3x notewrite notewrite" title="이 노트를 이용해 새 노트 작성"></i> &nbsp;</a> 
                         <a id="emailNoteBtn"><i class="far fa-envelope notewrite" title="노트 이메일로 발송"></i> &nbsp;</a> 
                         <a id="downloadPdfBtn"><i class="fas fa-arrow-down notewrite" title="노트 다운로드"></i> &nbsp;</a> 
                         <a id="scrapNoteBtn"><i class="fas fa-archive notewrite" title="노트 스크랩"></i> &nbsp;</a> 
                          <a id="noteReportForm"><i class="fas fa-flag notewrite" title="노트 신고"></i> &nbsp;</a> 
                     </c:otherwise>   
                  </c:choose> 
                  <c:if test="${param.write eq 'y'}"> <a id="addToNoteBtn"><i class="far fa-hand-point-up notewrite" title="작성 중인 노트에 추가"></i> &nbsp;</a> </c:if>
                  </se:authorize>
                  <se:authorize access="!hasAnyRole('ROLE_USER', 'ROLE_ADMIN')"> <!-- 비회원인 경우 아이콘 노출 안 함 -->
                  </se:authorize>
                  </strong>
               </div>
            </div>

         </div>
         
         <!-- modal-footer-->
         <div class="modal-footer">
            <div class="">
               <div class="comment-box">
               <!-- 노트 댓글 리스트 -->
                  <ul id="noteCommList"class="list-unstyled ui-sortable" ></ul>


                     <!-- 로그인한 회원,어드민들 댓글창 -->
                     <se:authorize access="hasAnyRole('ROLE_USER', 'ROLE_ADMIN')">
                     <div class="noteComm-inputBox input-group">
                        <input type="text" id="userComment"
                           class="form-control input-sm chat-input" placeholder="댓글을 입력하세요" />
                        <span class="input-group-btn commentBtn">
                           <a href="#" class="btn main-btn center-block commentBtn" id="commentBtn">
                              <i class="fas fa-check notewrite" title="댓글 신고"></i> Add Comment
                           </a>
                        </span>
                     </div>
                     </se:authorize>
                     <!-- 비회원일때 댓글창 -->
                     <se:authorize access="!hasAnyRole('ROLE_USER', 'ROLE_ADMIN')">
                        <div class="noteComm-inputBox input-group">
                           로그인 후 이용해주세요
                        </div>
                     </se:authorize>
                     </div>
                     
                  
                  
               </div>      
               <!-- 닫기버튼 -->
               <input type="button" class="btn btn-default mr-10" data-dismiss="modal"
                  value="Close" id="empbutton" />
               <div class="col-xs-10" id="lblstatus"></div>
            </div>
         </div>
      </div>
   </div>

<script>

$(document).ready(function(){
   //페이지 로딩시 댓글리스트 출력
   makeNoteCommList(${note.noteNum})   
     /* 댓글등록 */

     $('.commentBtn').click(function insertNoteComm(event){
        if($('#userComment').val()==""){
         /* swal("", "내용을 입력해주세요", "warning"); */
      }else{
        event.stopPropagation();
        $.ajax({
           url : "<%=request.getContextPath()%>/note/insertNoteComm.json",
            type : "post",
            async: false,
            data : {
               "CommContent": $('#userComment').val(),
               "noteNum":${note.noteNum}
            },
            success : function(data){
               $('#userComment').val("");
              makeNoteCommList(${note.noteNum});
              ws.send("${note.userEmail}");
            }
        })}
            
     }) 
    
   
   

   /* 노트 댓글 조회 */
   function makeNoteCommList(noteNum) {
      var userEmail = '${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}';
      var role='${sessionScope.SPRING_SECURITY_CONTEXT.authentication.authorities}';
   
         $.ajax({
            url : "<%=request.getContextPath()%>/note/selectAllNoteComm.json",
             type : "post",
             data : {
                "noteNum":noteNum
             },
             success : function(data){
                  var noteCommList = "";
                   if(data !=null) {
                       $.each(data, function(key, value){
                         $('#noteCommList').empty();
                         noteCommList += '<div class="col-lg-12 col-sm-12 text-left noteCommList">';
                         noteCommList += '   <div class="media-left">';
                         if (value.userSocialStatus == 0){
                         	noteCommList += '   <img class="user_photo" src="${pageContext.request.contextPath}/resources/image/userPhoto/'+value.userPhoto+'">';
                         } 
                         if (value.userSocialStatus>0) {
                        	noteCommList += '   <img class="user_photo" src="'+value.userPhoto+'">';
                         }
                         noteCommList += '   </div>';
						 noteCommList += '      <div class="media-body comment">';
                         noteCommList += '             <strong class="pull-left primary-font">';
                         /*    대댓글일때 */
                         if(value.commDept==1){
                            noteCommList += '                     ㄴ';   
                         }
                         noteCommList += '                     <span>'+value.userNick+'</span></strong>';
                         noteCommList += '                         <small> &ensp;'+value.commDate+'</small><br>';
                         noteCommList += '                         <small class="pull-right text-muted"> ';
                         /*  본인이거나 삭제버튼  */
                         if(value.userEmail==userEmail){
                            noteCommList += '                      <a id="noteCommDelete"><i class="fas fa-trash noteCommTrashBtn notewrite" title="댓글 삭제">';
                            noteCommList += '                        <input id="noteCommNum" type="hidden" value="'+value.noteCommNum+'" />';
                            noteCommList += '                     </i></a>&ensp;&ensp;';
                         
                         }  
                         /* 댓글하나일때 노트작성자 대댓글버튼생성 */ 
                         if(value.commDept==0 && '${note.userEmail}'==userEmail){
                            noteCommList += '                <a id="noteCommCommBtn"> <i class="fas fa-comment noteCommCommBtn notewrite" title="댓글 달기">';
                            noteCommList += '                  <input id="noteCommNum" type="hidden" value="'+value.noteCommNum+'" />';
                            noteCommList += '                  <input id="noteCommPos" type="hidden" value="'+value.noteCommPos+'" />';                     
                            noteCommList += '                  <input id="commUserEmail" type="hidden" value="'+value.userEmail+'"/>';
                            noteCommList += '               </i></a>&ensp;&ensp;';
                         }  
                         
                         /* 타인의 글일때 신고 버튼 생성*/ 
                         if(value.userEmail!=userEmail){
                            noteCommList += '             <a id="noteCommReportForm" class="noteCommReportForm"> <i class="fas fa-flag notewrite" title="댓글 신고">';
                            noteCommList += '                  <input id="commWriter" type="hidden" value="'+value.userEmail+'" />';
                            noteCommList += '                  <input id="commContent" type="hidden" value="'+value.commContent+'" />';   
                            noteCommList += '                  <input id="noteCommNum" type="hidden" value="'+value.noteCommNum+'" />';
                            noteCommList += '                  <input id="noteNum" type="hidden" value="'+noteNum+'" />';
                            noteCommList += '          </i></a>&ensp;&ensp;';
                         }  
                  
                     noteCommList += '            </small>';
                     noteCommList += '         <!-- 댓글일때 본인이거나 admin일때 대댓글버튼 -->';
                     /* 댓글내용 출력 */
                     noteCommList += '          <div class="noteCommContent';
                     
                     /* 신고된 노트 댓글일때 표시 addclass...*/
                       if('${param.noteCommNum}'==value.noteCommNum){
                           noteCommList += ' reported ">';
                      }else{noteCommList += ' ">';}
                     
                     if(value.commDept==1){
                                 noteCommList += '&ensp;&ensp;';
                         }  
                     if(value.noteCommBlind==1){
                                 noteCommList += '삭제되거나 블라인드 처리된 댓글입니다.</div>';
                         } else{
                                 noteCommList += ''+value.commContent+'</div>';
                         }
                     
                     noteCommList += '      </div>';
                     noteCommList += '   </div>';
   
                     })
                  if (data.length == 0) {
                     noteCommList += "<div class='text-center'>";
                     noteCommList += "등록된 댓글이 없습니다.";
                     noteCommList += "</div>";
                     }
                  }
                   $('#noteCommList').html(noteCommList);
                  
                  
                     /* 대댓글 */
                     var commCommClickNum = 0;
                     var noteCommNum;
                     var noteCommPos;
                     var commUserEmail;
                     var commWriter;
                     var commContent;
                     
                     var commBoxHtml="<div class='noteComm-inputBox input-group noteCommCommBox'>"
                        +" <input type='text' id='userCommComm' class='form-control input-sm chat-input' style='margin-top:17px;' placeholder='답댓글을 입력하세요' />"
                        +" <span class='input-group-btn' id='commCommbtn'>"
                        +" <div>"
                        +' <button href="#" class="btn main-btn center-block" id="commCommentBtn">'
                        +' <i class="fas fa-check"></i> Add Comment'
                        +" </button></div>"
                        +" </span></div></div>";
                     
                     //대댓글등록
                     function insertCommComm(){
                        $.ajax({
                           url : "<%=request.getContextPath()%>/note/insertNoteCommComm.json",
                            type : "get",
                            data : {       
                               "commContent": $('#userCommComm').val(),
                               "noteNum":${note.noteNum},
                               "noteCommNum":noteCommNum,
                               "noteCommPos":noteCommPos
                            },
                            success : function(data){
                               commCommClickNum=0;
                               noteCommNum="";
                               noteCommPos="";
                               makeNoteCommList(${note.noteNum});
                               ws.send(commUserEmail);
                            },
                            error:function(request,status,error){
                                   console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                               }
                        });   
                        
                        
                     }
                        
                         /* 대댓글아이콘 클릭시 */
                        $('.noteCommCommBtn').on("click",function() {
                        if(commCommClickNum==0){
                           noteCommNum=$(this).find('#noteCommNum').val();
                           noteCommPos=$(this).find('#noteCommPos').val();
                           commUserEmail=$(this).find('#commUserEmail').val();
                           commCommClickNum=1;
                           $(this).parents('.comment').append(commBoxHtml);
                           /* 대댓글 작성 버튼 클릭시 */
                           $('#commCommentBtn').click(function(){
                              if($('#userCommComm').val()==""){
                                 swal("", "내용을 입력해주세요", "warning");
                              }else{
                              insertCommComm()
                              }
                           });
                        }else if(commCommClickNum==1){
                           $('.noteCommCommBox').remove();
                           noteCommNum=$(this).find('#noteCommNum').val();
                           noteCommPos=$(this).find('#noteCommPos').val();
                           commUserEmail=$(this).find('#commUserEmail').val();
                           $(this).parents('.comment').append(commBoxHtml);
                           /* 대댓글 작성 버튼 클릭시 */
                           $('#commCommentBtn').click(function(){
                              if($('#userCommComm').val()==""){
                              /*    swal("", "내용을 입력해주세요", "warning"); */
                              }else{
                              insertCommComm()
                              }
                           });
                        }
                        /* 대댓글 화면 닫기 */
                           $('.noteCommCommExit').click(function(){
                              $('.noteCommCommBox').remove();
                              commCommClickNum=0;
                           });
                        });
                        
                        
                        
                        

                        

                     
                  
                     /* 대댓글 */
                  
                     /* 댓글삭제*/
                     $('.noteCommTrashBtn').click(function deleteNoteComm() {
                        noteCommNum=$(this).children('#noteCommNum').val();
                        noteCommPos=$(this).children('#noteCommPos').val();
                        swal({
                             title: "댓글을 삭제하시겠습니까?",
                             type: "warning",
                             confirmButtonClass: "btn-danger btn-sm",
                             cancelButtonClass: "btn-sm",
                             confirmButtonText: "OK",
                             showCancelButton: true
                           },
                           function(isConfirm) {
                             if (isConfirm) {
                               $.ajax({
                                     url : "<%=request.getContextPath()%>/note/deleteNoteComm.json",
                                     type : "get",
                                     data : {
                                        "noteCommNum":noteCommNum
                                     },
                                     success : function(data){
                                        qnaCommNum="";
                                        makeNoteCommList(${note.noteNum})
                                     
                                     },
                                     error : function(){
                                        swal({
                                            title: "댓글 삭제에 실패하였습니다",
                                            text: "",
                                            type: "warning",
                                            confirmButtonClass: "btn-danger btn-sm",
                                            confirmButtonText: "OK",
                                          });
                                     }
                              });
                             } 
                           }); 
                     }); 
                     /* 댓글삭제 */
                  
                     
                     //신고 모달 클릭시 db 댓글 조회
                     $('.noteCommReportForm').click(function noteCommReport() {
                        commWriter=$(this).find('#commWriter').val();
                        commContent=$(this).find('#commContent').val();
                        var noteNum= $(this).find('#noteNum').val();
                        var noteCommNum =$(this).find('#noteCommNum').val()
                         var commReportText = '<form style="font-size:15px;"><br><p><strong>댓글 작성자</strong> <span id="commWriterOut">'+commWriter+'</span></p>'+
                         '<p><strong>댓글 내용</strong> <span id="commContentOut">'+commContent+'</span></p>'+
                         '<input type="hidden" value=${note.userEmail}/>'+
                        '</p><p style="padding-top: 10px;">'+
                        '<strong>신고 사유</strong>&ensp; <select name="causeCategory"'+
                        '   id="causeCategory">'+
                        '   <option >신고 사유를 선택하세요</option>'+
                        '   <option value="NR01">광고/음란성 게시물</option>'+
                        '   <option value="NR02">욕설 및 부적절한 언어</option>'+
                        '   <option value="NR03">회원비방/싸움조장</option>'+
                        '   <option value="NR04">명예훼손/저작권 침해</option>'+
                        '   <option value="NR00">기타</option>'+
                        '</select></p> <p style="padding-top: 10px;"><strong>신고 사유 상세</strong>'+
                        '</p><textarea rows="5" id="causeText" class="form-control textarea noresize"'+
                        'placeholder="신고 사유를 입력하세요"></textarea><br>'+
                        '<p align="center"><strong>위와 같은 내용으로 <br/>해당 댓글을 신고하시겠습니까?</strong>'+
                        '</p></div></form>'
                     
                        
                        swal({
                             title:'<span class="title">노트 댓글 신고</span>',
                             text: commReportText,
                             html: true,
                             inputAttributes: { autocapitalize: 'off' },
                             showCancelButton: true,
                             confirmButtonText : "OK",
                             confirmButtonClass : "btn-danger btn-sm",
                             cancelButtonClass : "btn btn-sm",
                             closeOnConfirm: false
                        },
                        function(){
                           $.ajax ({
                              url : '${pageContext.request.contextPath}/etc/insertReport.json',
                              type: "POST",
                              data : {
                                 "userEmail" : userEmail,
                                 "noteNum": noteNum,
                                 "noteCommNum" : noteCommNum,
                                 "noteOrCommCode" : 'NC01',//노트댓글신고코드
                                 "reportCauseCode" : $("#causeCategory option:selected").val(),
                                 "reportContent" : $('#causeText').val()  
                                 },
                           }).done(function(result) {
                              swal({type: "success",
                                   title: '관리자 확인 후 블라인드 처리됩니다.',
                                      confirmButtonClass : "btn-danger btn-sm",
                                   closeOnConfirm: true
                              },
                              function(){
                              
                              })
                              
                           
                           })
                           .fail(function(request,status,error){
                                   console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                               });
                        });
                     return false;
                  });
            
            }
      
         }).done(function (result){
        //프로필
         
         
         });
      
       
       
       
      }
      
   
   
   
   
      

})
</script>