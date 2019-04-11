<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:variable name="maxIlosc">
	<xsl:for-each select="/Wypozyczalnia/Klienci/Klient/Wypozyczenia">
		<xsl:sort select="count(Wypozyczenie/Sprzety/Element)" data-type="number" order="descending"/>
		<xsl:if test="position() = 1"><xsl:value-of select="count(Wypozyczenie/Sprzety/Element)"/></xsl:if>
	</xsl:for-each>
</xsl:variable>

<xsl:variable name="maxKwota">
	<xsl:for-each select="/Wypozyczalnia/Klienci/Klient/Wypozyczenia">
		<xsl:sort select="sum(Wypozyczenie/Informacje/Kwota)" data-type="number" order="descending"/>
		<xsl:if test="position() = 1"><xsl:value-of select="sum(Wypozyczenie/Informacje/Kwota)"/></xsl:if>
	</xsl:for-each>
</xsl:variable>

<xsl:template match="/">
  <html>
  <head>
	<style type="text/css">

		.klienciTable {
			display: table;
			width: 70%;
			margin: auto;
		}


		.klienciHeading {
			background-color: #EEE;
			display: flex;
			font-weight: 900;
			line-height: 2;
			font-size: 19px;
			text-transform: uppercase;
		}

		.klienciCell, .klienciHeadingCell{
			border: 1px solid #999999;
			display: flex;
			width: 100%;
			justify-content: center;
			align-items: center;
			text-align: center;
			background: #fcfcfc;
			line-height: 1.5;
			font-size: 16px;
		}

		.klienciHeadingCell:nth-child(1){
			width:50%;
		}

		.klienciCell:nth-child(1){
			width:50%;
		}

		.klienciRow{
			display:flex;
		}

		.klientDummyCell {
			border: 1px solid #ffffff;
			width:100%;
		}

		.klientDummyCell:nth-child(1){
			width:50%;
		}

		.summaryCell{
			font-weight: 900;
			color:blue;
			font-size:18px;
		}
		.przedmiotyTable { display: block; }
	</style>
  </head>
  <body>

    <div class="klienciTable">
		<div class="klienciBody">
			<div class="klienciHeading">
				<div class="klienciHeadingCell">Numer</div>
				<div class="klienciHeadingCell">Imie Nazwisko</div>
				<div class="klienciHeadingCell">Adres</div>
				<div class="klienciHeadingCell">Telefon</div>
				<div class="klienciHeadingCell">Email</div>
				<div class="klienciHeadingCell">Wypożyczeń</div>
				<div class="klienciHeadingCell">Łączna kwota</div>
			</div>

			<!-- ograniczamy dopasowanie do klientow -->
			<xsl:apply-templates select="/Wypozyczalnia/Klienci/Klient"/>
			<div class="klienciRow">
				<div class="klientDummyCell"></div>
				<div class="klientDummyCell"></div>
				<div class="klientDummyCell"></div>
				<div class="klientDummyCell"></div>
				<div class="klientDummyCell"></div>
				<div class="klienciCell summaryCell"><xsl:value-of select="count(/Wypozyczalnia/Klienci/Klient/Wypozyczenia/Wypozyczenie/Sprzety/Element)"/></div>
				<div class="klienciCell summaryCell"><xsl:value-of select="format-number(sum(/Wypozyczalnia/Klienci/Klient/Wypozyczenia/Wypozyczenie/Informacje/Kwota),'#0.00')"/></div>
			</div>
		</div>
	</div>

  </body>
  </html>
</xsl:template>

<xsl:template match="Klient">
	<div class="klienciRow">
		<div class="klienciCell">
			<xsl:number format="1."/>
		</div>
		<xsl:apply-templates/>
	</div>
</xsl:template>

<xsl:template match="DaneOsobowe">
	<div class="klienciCell">
		<xsl:value-of select="concat(Imie,' ',Nazwisko)"/>
	</div>
	<div class="klienciCell">
		<xsl:value-of select="concat(Adres/Kraj,', ',Adres/Miasto,', ',Adres/Ulica,' ',Adres/Dom,', ',Adres/KodPocztowy)"/>
	</div>
</xsl:template>

<xsl:template match="DaneKontaktowe">
	<div class="klienciCell">
		<xsl:value-of select="NumerTelefonu"/>
	</div>
	<div class="klienciCell">
		<xsl:choose>
			<xsl:when test="Email">
				<xsl:value-of select="Email"/>
			</xsl:when>
			<xsl:otherwise>brak</xsl:otherwise>
		</xsl:choose>
	</div>
</xsl:template>

<xsl:template match="Wypozyczenia">
	<xsl:variable name="posID" select="position()"/>
	<xsl:variable name="colorIlosc" select="count(Wypozyczenie/Sprzety/Element) div $maxIlosc * 255.0"/>
	<div class="klienciCell" style="background-color: rgb(0,{$colorIlosc},0)">
		<xsl:value-of select="count(Wypozyczenie/Sprzety/Element)"/>
	</div>
	<xsl:variable name="colorKwota" select="sum(Wypozyczenie/Informacje/Kwota) div $maxKwota * 255.0"/>
	<div class="klienciCell" style="background-color: rgb(0,{$colorKwota},0)">
		<xsl:value-of select="format-number(sum(Wypozyczenie/Informacje/Kwota),'#0.00')"/>
	</div>
</xsl:template>

</xsl:stylesheet>
