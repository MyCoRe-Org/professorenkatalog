						// data retrieval from PND Beacon AKS via AJAX (asynchron)
						//support for replaceLabels still needs to be done
						$(document).ready(function(){
							$("p.profkat-beacon-result").each(function(){
								var p = $(this);
								var ul = $('<ul style="list-style-position:inside"></ul>');
								var whitelist = null;
								var blacklist = null;
								try{
									whitelist = $.parseJSON(p.attr("data-profkat-beacon-whitelist"));
								}
								catch(e){}
								try{
									blacklist = $.parseJSON(p.attr("data-profkat-beacon-blacklist"));
								}
								catch(e){}
									
								p.append(ul);
								var url = $("meta[name='mcr:baseurl']").attr("content")+"profkat_beacon_data?gnd="+encodeURIComponent(p.attr("title")); 
								$.get(url, function(data){
									var data = data.substr(data.search("<html>"));
									data = data.replace('<html>', '<html xmlns="http://www.w3.org/1999/xhtml">');
									var doc = $.parseXML(data);
									$(doc).find("li").each(function(pos){
										var li=$(this);
										var test = $(li).attr("id");
										
										//we need to delete the position number at the end of the id:
										//RegEx for number at the end
										//test = test.replace(/\d+$/, "")										
										//it seems more safe to use the length of the position number (variable of the each-function) and do a substring()
										var part = ""+(pos + 1);
										test = test.substring(0, test.length-part.length);
										
										show = false;
										if(whitelist!=null){
											if($.inArray(test, whitelist)>=0){
												show=true;											
											}
										}
										if(blacklist!=null){
											if($.inArray(test, blacklist)>=0){
												show=false;											
											}
										}
														
										if(show){
											$(li).attr("data-profkat-beacon-testid", test);
											$(ul).append(li);
										}
									});
								});
				
							})
						});