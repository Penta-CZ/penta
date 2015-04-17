<?xml version='1.0' encoding="windows-1250"?>
<xsl:stylesheet
  version="1.0" exclude-result-prefixes="xsl msxsl dt rs z"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:dt="urn:schemas-microsoft-com:datatypes"
  xmlns:rs="urn:schemas-microsoft-com:rowset"
  xmlns:z="#RowsetSchema"  
  xmlns:lxslt="http://xml.apache.org/xslt"
  xmlns:u="urn:my-scripts" >
  
  <xsl:output method="html" indent="yes" omit-xml-declaration="yes"/>
  <xsl:decimal-format decimal-separator='.' grouping-separator=' ' />

  <xsl:variable name="sql2" select="i6report/sql_penta/xml[1]/rs:data/z:row"/>
  <xsl:variable name="sqlBanner" select="($sql2)[contains(@WenTagC,'Ban')]"/>
  <xsl:variable name="sqlBannerCistirnaExists" select="($sql2)[contains(@WenTagC,'iPen14 S10 Ban')]"/>
  <xsl:variable name="sqlProd" select="($sql2)[contains(@WenTagC,' Prod')]"/>
  <xsl:variable name="sqlCistirnaBottom" select="($sqlBanner)[last()]"/>  

  <!-- ===== promenne v pente ===== -->
  <xsl:variable name="server" select="'http://dealer.penta.cz'" />  
  <xsl:variable name="images_root" select="concat(($server),'/img/mailing2014')" />  

  <xsl:template match="/">

    <xsl:variable name="repcond" select="i6report/repcondtree/repcondtree/repcond"/>

    <xsl:variable name="title" select="$repcond[@code = '#Title#']/@value"/>    
    <xsl:variable name="mailnumber" select="$repcond[@code = '#MailNumber#']/@value"/>
    <xsl:variable name="maildate" select="$repcond[@code = '#WenValidBeg#']/@value"/>    

    <xsl:variable name="frmt_prc" select="'########0.00'"/>
    <xsl:variable name="frmt_prc_round" select="'########0'"/>

    <!-- ===== promenne v cybersoftu ===== -->
    <!-- xsl:variable name="server" select="'http://localhost/i6webs/penta/'" / -->

    <html>
      <head>
        <meta http-equiv="content-type" content="text/html; charset=windows-1250" />
        <title>iPenta - Produktové info</title>
      </head>
      <body bgcolor='white' heigh='100%'>
        <div>          
          <table name="top" width='725' height='159px' align='center' cellspacing='0' cellpadding='0' >
            <tr>
              <td width='365px' align='center'>
                <a href='{$server}' title='PENTA'>
                  <img src='{$images_root}/logo.jpg' width='200px' height='104' border='0' />
                </a>
              </td>
              <td width='66'>
                <a href='{$server}/default.asp?cls=catalog&amp;xsl=xsearch' title='Hledat'>
                  <img src='{$images_root}/search.jpg' width='66' height='105' border='0' />
                </a>
              </td>
              <td width='5'>&#160;</td>
              <td width='90'>
                <a href='{$server}/default.asp?inc=inc/kontakt.htm' title='Kontakt'>
                  <img src='{$images_root}/contact.jpg' width='90' height='105' border='0' />
                </a>
              </td>
              <td width='5'>&#160;</td>
              <td width='90'>
                <a href='{$server}/default.asp?cls=catalog&amp;xsl=xcompany' title='Registrace'>
                  <img src='{$images_root}/register.jpg' width='90' height='105' border='0' />
                </a>
              </td>
              <td width='5'>&#160;</td>
              <td width='90'>
                <a href='{$server}/default.asp?cls=login' title='Přihlášení'>
                  <img src='{$images_root}/login.jpg' width='90' height='105' border='0' />
                </a>
              </td>
            </tr>
            <tr>
              <td align='center' width='725px' height='5px' colspan='8'>
                <img src='{$images_root}/yelline1.jpg' width='725px' height='5' />
              </td>
            </tr>
            <tr>
              <td align='center' width='725px' height='2px' colspan='8'></td>
            </tr>
            <tr>
              <td align='center' width='725px' height='25px'  bgcolor="#FFCB00"  colspan='8'>
                <div align='left'>
                  <p style="float:left;padding:0px 0px 0px 15px;font-family:'Century Gothic,CenturyGothic,AppleGothic,sans-serif'; font-size:12px;">Váš obchodník Rudolf Vaniš, e-mail: vanis@penta.cz, tel.:383369102, GSM;</p>
                  <p style="float:right; padding:0px 28px 0px 0px; font-family:'Century Gothic,CenturyGothic,AppleGothic,sans-serif'; font-size:12px;">
                    č. <xsl:value-of select="($mailnumber)"/> - <xsl:value-of select="($maildate)"/>
                  </p>
                </div>              
              </td>            
            </tr>
          </table>
        </div>

        <xsl:if test="$sql2">
          <div align="center">            
              <!-- products start -->            
              <xsl:for-each select="$sqlBanner">
                <xsl:variable name="section" select="substring(@WenTagC,9,2)" />
                
                <xsl:call-template name="banner">
                  <xsl:with-param name="section" select="$section" />
                  <xsl:with-param name="mailnum" select="$mailnumber" />
                </xsl:call-template>
                
                <table style="padding:5px 0px 0px 0px;" cellpadding="0" cellspacing="0" width="725px" height="370" align="center">                                                      
                  <xsl:if test="count(($sql2)[contains(@WenTagC,concat($section,' Prod'))]) >= 3">                                      
                    <xsl:for-each select="($sql2)[contains(@WenTagC,concat($section,' Prod'))]">                      
                        <xsl:call-template name="prodLine">
                           <xsl:with-param name="mailnum" select="$mailnumber" />                                                   
                        </xsl:call-template>                      
                        </xsl:for-each>
                  </xsl:if>
                </table>

                <!-- products end -->
                <!-- Cistirna - Kompletni vyprodej-->

                <xsl:if test="count($sqlBannerCistirnaExists) >= 1 and $section = 10">
                  <div align="center">
                    <a href="{$server}/vyprodej_c14200.html?utm_source=newsletter{$mailnumber}&amp;utm_medium=e-mail">
                      <img src="{$images_root}/cistirna/cistKomplVyprodej.jpg" border="0"  width="725" height="80" />
                    </a>
                  </div>
                </xsl:if>
                <!-- Cistirna - Kompletni vyprodej -->                

              </xsl:for-each>                                               
          </div>
        </xsl:if>

        <div style="padding:30px 0px 0px 0px">
        <table border='0' width='725px' align='center' cellspacing='0' cellpadding='0'>
          <tr>
            <td height='10' bgcolor='#FFCB00'></td>
          </tr>
        </table>
        </div>
        <table border='0' width='725px' align='center' cellspacing='0' cellpadding='0'>
          <tr>
            <td align='left' style ='padding-left:80px;'>
              <font face='Century Gothic,CenturyGothic,AppleGothic,sans-serif, Helvetica, sans-serif' color='#AAAAAA'>
                <span style='font-size:8pt;'>
                  V případě, že nemáte zájem nadále přijímat toto obchodní sdělení, odepište na e-mail: <a href="mailto:prodej@penta.cz?subject=Nezasílat reklamní sdělení&amp;body=Nezasílat žádná reklamní sdělení.">prodej@penta.cz</a>. <br/> Uvedené ceny jsou v Kč bez DPH, není-li uvedeno jinak. Vaše aktuální nákupní cena se zobrazí po přihlášení. <br /> Dodavatel si vyhrazuje právo na změnu ceny či technické specifikace bez udání důvodu. <br />Objednávky budou vyřizovány v pořadí přijetí. Použity ilustrační fotografie. <br />Za tiskové chyby neručíme. PHE: ( elekroodpad ), AO: ( autorský poplatek ). <br /> Společnost PENTA CZ s.r.o. je zapsána Krajským soudem České Budějovice, oddíl C, vložka 8816
                </span>
              </font>
            </td>
          </tr>
        </table>
        <table border='0' width='725px' align='center' cellspacing='0' cellpadding='0'>
          <tr height='19' bgcolor='#FFCB00'>
            <td>
              <font face='Century Gothic,CenturyGothic,AppleGothic,sans-serif, Helvetica, sans-serif' color='black'>
                <span style='font-size:8pt;'>
                  &#160;<xsl:text disable-output-escaping="yes">&amp;copy;</xsl:text> 2015 PENTA CZ s.r.o.
                </span>
              </font>
            </td>
            <td align='right'>
              <font face='Century Gothic,CenturyGothic,AppleGothic,sans-serif, Helvetica, sans-serif'>
                <span style='font-size:8pt;'>
                  <a href='#top'>
                    <font color='#979797'>
                      NAHORU
                    </font>
                  </a>&#160;
                </span>
              </font>
            </td>
          </tr>
        </table>

      </body>
    </html>

  </xsl:template>

  <xsl:template name="banner">
    <xsl:param name="section" />
    <xsl:param name="mailnum" />
    <!--tiles-->
          
      <xsl:if test="$section != 1">
        <div style=" margin-top: 30px;">
        </div>
      </xsl:if>

      <xsl:if test="$section = 1">
        <div style="margin-top: 10px;">
        </div>
      </xsl:if>

      <!-- img -->

      <xsl:choose>        
        <xsl:when test="@WenPictWidth != 0 and @WenPictHeight != 0">
          <a href="{@WenUrlLink}?utm_source=newsletter{$mailnum}&amp;utm_medium=e-mail">
            <img src="{$server}/webnews/{@WenId}.{@WenPictType}" border="0"  width="725" />          
          </a>
        </xsl:when>
        <xsl:otherwise>
          <table style="text-align:center;" width="725" >
            <td style="padding: 30px 10px 10px 40px;">
              <a style="text-decoration: none;color:black;font-family:'Arial Black'; font-weight:bold;font-size:30px;Text-transform:uppercase;" href="{@WenUrlLink}">
                <xsl:value-of select="@WenName" />
              </a>
          </td>
            </table>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <xsl:template name="prodLine">
    <xsl:param name="mailnum" />
      
    <xsl:if test="(position() - 1) mod 3= 0">
      <tr/>
    </xsl:if>        
    <td width="242" height="370">
      <!-- item start -->          
                        <xsl:choose>
                          <xsl:when test="@WenTextLink = ''">
                            <a href="{@WenUrlLink}">
                          <div style="border:1px solid #dfdfdf;">                              
                                <img src="{$server}/webnews/{@WenId}.{@WenPictType}" border="0" height="100%" width="242" />                                                                                   
                          </div>
                            </a>
                          </xsl:when>
                       <xsl:otherwise> 
                           <xsl:call-template name="product">
                              <xsl:with-param name="mailnum" select="$mailnum" />                           
                            </xsl:call-template>
                       </xsl:otherwise>
                       </xsl:choose>
                       
    </td>     
  <!-- item end -->   
  </xsl:template>        
      
    
  <xsl:template name="product">      
    <xsl:param name="mailnum" />
      
    <div id="tableCell">            
      <table style="border:1px solid #dfdfdf;" cellpadding="0" cellspacing="0" border="0">        
        <tr>
          <td width="242" height="370" bgcolor="#979797">
            <table  width="242" height="370" cellpadding="0" cellspacing="0" bgcolor="white" style="table-layout:fixed;overflow:hidden">                        
              
              <td height="20" style="font-family:Century Gothic,CenturyGothic,AppleGothic,sans-serif; text-align:left; font-weight:bold;">                       
                <xsl:variable name="statusy" select="u:iif(@StiXSisId = 2,'vyprodej.png',u:iif(@StiXSisId = 4,'sncena.png',u:iif(@StiXSisId = 13,'akce.png',u:iif(@StiXSisId = 1,'novinka.png','NOIMAGE'))))"/>
                       <xsl:if test ="($statusy) != 'NOIMAGE'">
                         <a href="{$server}/{@linkUrl}?utm_source=newsletter{$mailnum}&amp;utm_medium=e-mail">
                           <img height="20" src="{$images_root}/statusy/{$statusy}" border="0" />                          
                         </a>
                      </xsl:if>                             
              </td>  
              
              <tr>                  
                  <td width="242" height="190" align="center" style="padding:10px 0px 0px 0px;vertical-align:center;position:relative;">                                                                                                      
                    <a href="{$server}/{@linkUrl}?utm_source=newsletter{$mailnum}&amp;utm_medium=e-mail">                      
                      <img src="{$server}/img.asp?stiid={@StiId}" border="0"  height="80%" />                      
                    </a>                                                                                                    
                  </td>                 
                </tr>                                            
                            
              <tr>                                
                <td width="242" height="20" style="padding:0px 15px 0px 15px;font-family:'Century Gothic,CenturyGothic,AppleGothic,sans-serif'; font-weight:bold;font-size:16px;line-height:20px;text-align:left;">
                  <!-- title -->
                  <a style="text-decoration: none;color:black" href="{$server}/{@linkUrl}?utm_source=newsletter{$mailnum}&amp;utm_medium=e-mail">                    
                    <xsl:value-of select="substring(@Branch, 1, 40)"/>                    
                  </a>
                </td>                
              </tr>              
              <tr>                
                  <td width="242" height="20" style="padding:0px 15px 0px 15px;font-family:'Century Gothic,CenturyGothic,AppleGothic,sans-serif'; font-size:15px;line-height:18px;text-align:left;">
                  <!-- model -->                    
                  <xsl:value-of select="substring(concat(@StiTag,concat(' ', @StiTag2)), 1, 25)"/>
                  <xsl:if test ="string-length (concat(@StiTag,concat(' ', @StiTag2))) > 25">
                    ...
                  </xsl:if>                    
                </td>                
              </tr>
              <tr>

                  <td width="242" height="80" style="padding:0px 15px 0px 15px;font-family:'Century Gothic,CenturyGothic,AppleGothic,sans-serif'; font-size:11px;line-height:12px;text-align:left;vetical-align:top">
                  <!-- note -->
                  <xsl:value-of select="substring(@StiShortPLNote,1,200)"/>
                  <xsl:if test ="string-length(@StiShortPLNote) >= 200">
                    ...
                  </xsl:if>
                  </td>
                
              </tr>             
                <tr>                
                <td width="242" height="40">                  
                  <!-- price, detail -->
                  <table cellpadding="0" cellspacing="0" width="242" height="20" align="center">                                                          
                    <tr>                      
                      <td width="50%" height="40" style="padding:0px 15px 0px 15px;color:gray; font-family:Century Gothic,CenturyGothic,AppleGothic,sans-serif; font-weight:bold; font-size:17px; line-height:21px; text-align:left;text-decoration:line-through;">
                        
                        <xsl:if test ="(@SipPrcList) > @Price">
                          <xsl:value-of select="format-number(number(@SipPrcList), '### ### ##0') "/> Kč
                        </xsl:if>
                        
                      </td>                      
                      
                      <td width="50%" height="40" style="font-family:Century Gothic,CenturyGothic,AppleGothic,sans-serif; font-size:20px; line-height:24px; ont-weight:bold;text-align:center;
                          background-color:{u:iif(@StiXSisId = 2,'black',u:iif(@StiXSisId = 4,'#39A935',u:iif(@StiXSisId = 13,'#cc3333','#FFCB00')))};
                          color:{u:iif(@StiXSisId = 2,'white',u:iif(@StiXSisId = 4,'white',u:iif(@StiXSisId = 13,'white','black')))};                          
                          ">
                        <xsl:value-of select="format-number(number(@Price), '### ### ##0') "/> Kč
                      </td>
                      
                    </tr>
                  </table>                  
                </td>                
              </tr>              
            </table>            
          </td>
          <td width="5" height="370"></td>
        </tr>
        <tr>
          <td width="260" height="1" colspan="2"></td>
        </tr>        
      </table>      
    </div>    
      
  </xsl:template>
  
  <msxsl:script language="JScript" implements-prefix="u"> 
 <![CDATA[
 
    function iif(condition,truePart,falsePart)
    {
     if (condition){
     return truePart;
     }
     else {
     return falsePart;
     }
   }               
  ]]>  
 </msxsl:script> 

</xsl:stylesheet>
