<?xml version="1.0"?>
<!-- @copyright Elsevier UCD -->
<!-- @author Stefan Kuip -->
<!-- @date 2013-09-16 -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:bk="http://www.elsevier.com/xml/bk/dtd"
	xmlns:cals="http://www.elsevier.com/xml/common/cals/dtd"
	xmlns:ce="http://www.elsevier.com/xml/common/dtd"
	xmlns:ja="http://www.elsevier.com/xml/ja/dtd"
	xmlns:mml="http://www.w3.org/1998/Math/MathML"
	xmlns:sb="http://www.elsevier.com/xml/common/struct-bib/dtd"
	xmlns:tb="http://www.elsevier.com/xml/common/table/dtd"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:xocs="http://www.elsevier.com/xml/xocs/dtd"
	xmlns:xoe="http://www.elsevier.com/xml/xoe/dtd"
	exclude-result-prefixes="bk cals ce ja mml sb tb xlink xocs xoe"
>
	<xsl:output encoding="UTF-8" method="xml" omit-xml-declaration="yes" indent="yes" />

	<xsl:template match="xocs:copyright-line">
		<p class="copyright">
			<xsl:apply-templates />
		</p>
	</xsl:template>

	<xsl:template match="xocs:doi">
		<a class="extern js_extern" href="http://dx.doi.org/{.}">
			<xsl:text>http://dx.doi.org/</xsl:text>
			<xsl:apply-templates />
		</a>
	</xsl:template>

</xsl:stylesheet>
