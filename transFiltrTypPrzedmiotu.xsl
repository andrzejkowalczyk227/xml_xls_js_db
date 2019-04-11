<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="pTyp"/>
<xsl:variable name="hostname">http://localhost:8000/</xsl:variable>

<xsl:template match="/">
  <html>
  <head>
    <style type="text/css">
      body{
  			font-family:Sans-serif;
  		}
  		#naglowek{background-color: #fcaaab;}

      img{
        max-height:180px;
        height:100%;
        transform:scale(1);
        transition:transform 1s;
      }

      img:hover{
        cursor:pointer;
        transform: scale(3) translate(0%,22%);
        transition:transform 1s;
        z-index:11;
      }

  		.sprzetyTable {
  			display: table;
  			width: 70%;
  			margin: auto;
  		}

  		.sprzetyHeading {
  			background-color: #EEE;
  			display: flex;
  			font-weight: 900;
  			line-height: 2;
  			font-size: 19px;
  			text-transform: uppercase;
  		}

  		.sprzetyCell, .sprzetyHeadingCell{
  			border: 1px solid #999999;
  			display: flex;
  			width: 100%;
  			justify-content: center;
  			align-items: center;
  			text-align: center;
  			background: #fcfcfc;
  			line-height: 1.5;
  		}

  		.sprzetyRow{
  			display:flex;
  		}

  		.sprzetyRow:hover{
  			cursor:pointer;
  		}

  		.przedmiotyHeading{
  			font-weight:900;
  			width: 19.99%;
  			margin:1vh 0;
  		}

  		.przedmiotyRow{
  			width: 79.99%;
  			margin:1vh 0;
  		}

  		.przedmiotyRow .przedmiotyCell:nth-child(1){
  			border-top:2px  solid #999999;
  			background-color:#98cce9;
  		}

  		.przedmiotyRow .przedmiotyCell:nth-last-child(1){
  			border-bottom:2px  solid #999999;
  		}


  		.przedmiotyHeading .przedmiotyHeadingCell:nth-child(1){
  			border-top:2px  solid #999999;
  			background-color:#98cce9;
  		}

  		.przedmiotyHeading .przedmiotyHeadingCell:nth-last-child(1){
  			border-bottom:2px  solid #999999;
  		}

  		.przedmiotyCell{
  			border: 1px solid #999999;
  			display: flex;
  			width: 100%;
  			justify-content: center;
  			align-items: center;
  			line-height: 1.5;
  		}

      .przedmiotyCellImg{
        width:100%;
      }

      .przedmiotyHeadingCellImg{
        max-height:180px;
        height:100vh;
      }

      .przedmiotyHeadingCell{
  			border: 1px solid #999999;
  			display: flex;
  			width: 100%;
  			justify-content: center;
  			align-items: center;
  			line-height: 1.5;
  		}

  		.przedmiotyTable {
  			display: block;
  		}

  		.przedmiotyBody{
  			display: flex;
  			flex-wrap: wrap;
  		}

  		.sprzetyBody {
  			display: table-row-group;
  			table-layout: fixed;
  			width: 100%;
  		}
  	</style>
  </head>
  <body>

    <div class="sprzetyTable">
		<div class="sprzetyBody">
			<div class="sprzetyHeading">
				<div class="sprzetyHeadingCell">Id</div>
				<div class="sprzetyHeadingCell">Z oferty</div>
				<div class="sprzetyHeadingCell">Opis</div>
				<div class="sprzetyHeadingCell">Dostepny</div>
				<div class="sprzetyHeadingCell">Tagi</div>
			</div>
			<!-- zastosuj templaty dla node'ow zwroconych poniższym wyrazeniem xpath (filtrowanie)-->
			<xsl:apply-templates select="/Wypozyczalnia/Magazyn//Sprzet/*[name()=$pTyp]/ancestor::Sprzet"/>
		</div>
	</div>

  <script>
		function dropdownFunc(nr) {
			var table = document.getElementById("przedmiot"+nr);
			if(table.style.display == "none")
				table.style.display = "block";
			else
				table.style.display = "none";
		}
  </script>
  </body>
  </html>
</xsl:template>

<xsl:template match="Sprzet">
		<xsl:variable name="pozycja" select="position()"/>
		<div class="sprzetyRow" onclick="dropdownFunc({$pozycja})">
			<div class="sprzetyCell"><xsl:value-of select="@ids"/></div>
			<div class="sprzetyCell"><xsl:value-of select="../Informacje/Opis"/></div>
			<div class="sprzetyCell"><xsl:value-of select="Informacje/Opis"/></div>
			<xsl:choose>
				<xsl:when test="@dostepny='true'">
					<div class="sprzetyCell" style="background-color: #8ffc85">tak</div>
				</xsl:when>
				<xsl:otherwise>
					<!-- jezeli jest wypozyczone to szukamy daty kiedy ma byc zwrocone-->
					<div class="sprzetyCell" style="background-color: #ff7f7f">
						<xsl:variable name="id" select="@ids"/>
						<xsl:value-of select="/Wypozyczalnia/Klienci/Klient/Wypozyczenia/Wypozyczenie/Sprzety/Element[@idsref=$id]/../../Informacje/TerminZwrotu"/>
					</div>
				</xsl:otherwise>
			</xsl:choose>
			<div class="sprzetyCell">
			<xsl:for-each select="ancestor::Kategoria">
				<xsl:value-of select="concat('#',@nazwa)"/>
			</xsl:for-each>
			</div>
		</div>
		<div class="przedmiotyTable" id="przedmiot{$pozycja}">
			<div class="przedmiotyBody">
				<!-- podejscie proceduralno/iteracyjne
					 ze wzgledu na swobodne definicje typow przedmiotow i ich struktury,
					 fakt ze nie zmienia sie kontekst tez jest calkiem przydatny-->
				<xsl:call-template name="Przedmioty"/>
			</div>
		</div>
</xsl:template>

<xsl:template name="Przedmioty">
	<!-- dla kazdego przedmiotu w zestawie -->
	<xsl:for-each select="child::*[position()>1]">
		<xsl:call-template name="headerPrzedmiot"/>
		<xsl:call-template name="contentPrzedmiot"/>
	</xsl:for-each>
</xsl:template>

<xsl:template name="headerPrzedmiot">
	<!--serwis jest opcjonalny wiec nie mozemy sie go pozbyc z selectu za pomoca pozycji-->
	<div class="przedmiotyHeading">
	<div class="przedmiotyHeadingCell">Typ</div>
	<xsl:for-each select="descendant::*[not(name()='Serwis' or name()='DaneTechniczne' or name()='Technologia')]">
		<!-- nie chcemy listowac szczegolow serwisu wiec pomijamy wszystkie nody ktore sa jego dziecmi -->
    <xsl:if test="name()='Zdjecie'">
      <div class="przedmiotyHeadingCell przedmiotyHeadingCellImg" ><xsl:value-of select="name()"/></div>
    </xsl:if>

    <xsl:if test="count(ancestor::Serwis)=0 and name()!='Zdjecie'" >
			<div class="przedmiotyHeadingCell"><xsl:value-of select="name()"/></div>
		</xsl:if>
	</xsl:for-each>
	</div>
</xsl:template>

<xsl:template name="contentPrzedmiot">
	<div class="przedmiotyRow">
	<!--<div class="przedmiotyCell"><xsl:number count="../child::*[position()>1]" format="1"/></div>-->
	<div class="przedmiotyCell"><xsl:value-of select="name()"/></div>
	<xsl:for-each select="descendant::*[not(name()='Serwis' or name()='DaneTechniczne' or name()='Technologie' or name()='Technologia')]">
		<xsl:if test="count(ancestor::Serwis)=0">
			<xsl:choose>
				<xsl:when test="name()='Zdjecie'">
					<div class="przedmiotyCell"><img src="{concat($hostname,text())}"/></div>
				</xsl:when>
				<xsl:otherwise>
					<div class="przedmiotyCell"><xsl:value-of select="."/></div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:for-each>
	<xsl:if test="descendant::Technologie"> <!-- jezeli istnieje -->
		<!--  NIE DZIALA BO XPATH 1.0 :((( <div class="przedmiotyCell"><xsl:value-of select="string-join(DaneTechniczne/Technologie/Technologia/text(),'')"/></div>-->
		<div class="przedmiotyCell">
		<xsl:for-each select="DaneTechniczne/Technologie/Technologia">
			<xsl:choose>
				<xsl:when test="position()=last()">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(.,', ')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		</div>
	</xsl:if>
	</div>
</xsl:template>

</xsl:stylesheet>
